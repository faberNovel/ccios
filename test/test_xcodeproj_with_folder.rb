require 'minitest/autorun'
require_relative '../lib/ccios/templates_loader'
require_relative '../lib/ccios/file_creator'
require 'tempfile'
require 'tmpdir'
require 'xcodeproj'

class XcodeProjWithFolderTest < Minitest::Test

  def setup
    FileCreator.logger.level = Logger::ERROR
    @test_dir = set_up_project_in_temporary_directory
  end

  def teardown
    FileUtils.remove_entry(@test_dir)
  end

  [false, true].each do |use_suffix|
    method_suffix = use_suffix ? "_with_suffix" : ""
    name = use_suffix ? "CotestCoordinator" : "Cotest"
    define_method "test_coordinator_folders#{method_suffix}" do
      generate_and_assert(
        xcodeproj_group: Proc.new { |parser, template, config|
          template_config = config.variables_for_template(template)
          project = parser.project_for template_config["project"]
          group = project[template_config["base_path"]]
          group
        },
        source_path: "MyProject/GroupWithFolder/Coordinator",
        template_name: "coordinator",
        name: name,
        expected_files: ["CotestCoordinator.swift"]
      )
    end
  end

  [false, true].each do |use_suffix|
    method_suffix = use_suffix ? "_with_suffix" : ""
    name = use_suffix ? "IntestInteractor" : "Intest"
    define_method "test_interactor_folders#{method_suffix}" do
      generate_and_assert(
        xcodeproj_group: Proc.new { |parser, template, config|
          template_config = config.variables_for_template(template)
          project = parser.project_for template_config["project"]
          group = project[template_config["base_path"]]
          group
        },
        source_path: "MyProject/GroupWithFolder/Interactor",
        template_name: "interactor",
        name: name,
        expected_files: [
          "IntestInteractor/IntestInteractor.swift",
          "IntestInteractor/IntestInteractorImplementation.swift"
        ]
      )
    end
  end

  [false, true].each do |use_suffix|
    method_suffix = use_suffix ? "_with_suffix" : ""
    name = use_suffix ? "PretestPresenter" : "Pretest"
    define_method "test_presenter_folders#{method_suffix}" do
      generate_and_assert(
        xcodeproj_group: Proc.new { |parser, template, config|
          template_config = config.variables_for_template(template)
          project = parser.project_for template_config["project"]
          group = project[template_config["base_path"]]
          group
        },
        source_path: "MyProject/GroupWithFolder/Presenter",
        template_name: "presenter",
        name: name,
        expected_files: [
          "Pretest/UI/View",
          "Pretest/UI/ViewController/PretestViewController.swift",
          "Pretest/UI/PretestViewContract.swift",
          "Pretest/Presenter/PretestPresenter.swift",
          "Pretest/Presenter/PretestPresenterImplementation.swift",
          "Pretest/Model"
        ]
      )
    end
  end

  [false, true].each do |use_suffix|
    method_suffix = use_suffix ? "_with_suffix" : ""
    name = use_suffix ? "RetestRepository" : "Retest"
    define_method "test_repository_data_folders#{method_suffix}" do
      generate_and_assert(
        xcodeproj_group: Proc.new { |parser, template, config|
          template_config = config.variables_for_template(template)
          project = parser.project_for template_config["project"]
          element_config = config.variables_for_template_element(template, "repository_implementation")
          group = project[element_config["base_path"]]
          group
        },
        source_path: "MyProject/GroupWithFolder/Repository",
        template_name: "repository",
        name: name,
        expected_files: ["Retest/RetestRepositoryImplementation.swift"]
      )
    end
  end

  [false, true].each do |use_suffix|
    method_suffix = use_suffix ? "_with_suffix" : ""
    name = use_suffix ? "RetestRepository" : "Retest"
    define_method "test_repository_core_folders#{method_suffix}" do
      generate_and_assert(
        xcodeproj_group: Proc.new { |parser, template, config|
          template_config = config.variables_for_template(template)
          project = parser.project_for template_config["project"]
          element_config = config.variables_for_template_element(template, "repository")
          group = project[element_config["base_path"]]
          group
        },
        source_path: "MyProject/GroupWithFolder/Interactor",
        template_name: "repository",
        name: name,
        expected_files: ["Retest/RetestRepository.swift"]
      )
    end
  end

  private

  def setup_parser
    yml_path = File.join(@test_dir, ".ccios.yml")
    File.open(yml_path, "w") do |io|
      io.puts ccios_yml_with_folders_content
    end

    config = Config.parse yml_path
    parser = PBXProjParser.new(@test_dir, config)
    yield(config, parser)
  end

  def generate_and_assert(xcodeproj_group:, source_path:, template_name:, name:, expected_files:)
    setup_parser do |config, parser|
      template = TemplatesLoader.new.get_templates(config)[template_name]
      raise "Template not found #{template_name}" if template.nil?

      group = xcodeproj_group.call(parser, template, config)
      assert_empty group.children, "#{group.display_name} group should not contain anything #{group.children}"

      template.generate(parser, {"name" => name}, config)

      assert_group_and_subgroups_have_no_name(group)

      expected_files.each do |file_name|
        expected_path = File.join(@test_dir, source_path, file_name)
        assert File.exist?(expected_path), "File #{expected_path} does not exist"
        refute_nil group[file_name]
      end
    end
  end

  def assert_group_and_subgroups_have_no_name(group)
    subgroups = group.children.select { |o| o.isa == "PBXGroup" }
    subgroups.each { |subgroup|
      assert_nil subgroup.name
      refute_nil subgroup.path
      # recursively test children
      assert_group_and_subgroups_have_no_name subgroup
    }
  end

  def set_up_project_in_temporary_directory
    dir = Dir.mktmpdir("ccios-tests", "/tmp")
    project_path = File.join(Dir.pwd, "test", "project")
    FileUtils.copy_entry project_path, dir
    dir
  end

  def ccios_yml_with_folders_content
    <<-eos
variables:
  project: MyProject.xcodeproj

templates_config:
  repository:
    variables: {}
    elements_variables:
      repository:
        base_path: MyProject/GroupWithFolder/Interactor
      repository_implementation:
        base_path: MyProject/GroupWithFolder/Repository
  presenter:
    variables:
      base_path: MyProject/GroupWithFolder/Presenter
  coordinator:
    variables:
      base_path: MyProject/GroupWithFolder/Coordinator
  interactor:
    variables:
      base_path: MyProject/GroupWithFolder/Interactor
eos
  end

end
