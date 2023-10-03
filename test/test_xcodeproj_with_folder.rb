require 'minitest/autorun'
require_relative '../lib/ccios/coordinator_generator'
require_relative '../lib/ccios/interactor_generator'
require_relative '../lib/ccios/presenter_generator'
require_relative '../lib/ccios/repository_generator'
require_relative '../lib/ccios/pbxproj_parser'
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
        xcodeproj_group: Proc.new { |parser| parser.coordinator_group },
        source_path: "MyProject/GroupWithFolder/Coordinator",
        generator_class: CoordinatorGenerator,
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
        xcodeproj_group: Proc.new { |parser| parser.interactor_group },
        source_path: "MyProject/GroupWithFolder/Interactor",
        generator_class: InteractorGenerator,
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
        xcodeproj_group: Proc.new { |parser| parser.presenter_group },
        source_path: "MyProject/GroupWithFolder/Presenter",
        generator_class: PresenterGenerator,
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
        xcodeproj_group: Proc.new { |parser| parser.repository_data_group },
        source_path: "MyProject/GroupWithFolder/Repository",
        generator_class: RepositoryGenerator,
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
        xcodeproj_group: Proc.new { |parser| parser.repository_core_group },
        source_path: "MyProject/GroupWithFolder/Interactor",
        generator_class: RepositoryGenerator,
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

  def generate_and_assert(xcodeproj_group:, source_path:, generator_class:, name:, expected_files:)
    setup_parser do |config, parser|
      group = xcodeproj_group.call(parser)
      assert_empty group.children, "#{group.display_name} group should not contain anything #{group.children}"

      generator = generator_class.new(parser, config)
      generator.generate(name)

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
app:
  project: MyProject.xcodeproj
  presenter:
    group: MyProject/GroupWithFolder/Presenter
  coordinator:
    group: MyProject/GroupWithFolder/Coordinator

core:
  project: MyProject.xcodeproj
  interactor:
    group: MyProject/GroupWithFolder/Interactor
  repository:
    group: MyProject/GroupWithFolder/Interactor

data:
  project: MyProject.xcodeproj
  repository:
    group: MyProject/GroupWithFolder/Repository
eos
  end

end
