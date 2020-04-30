require 'minitest/autorun'
require_relative '../lib/ccios/coordinator_generator'
require_relative '../lib/ccios/interactor_generator'
require_relative '../lib/ccios/presenter_generator'
require_relative '../lib/ccios/repository_generator'
require_relative '../lib/ccios/pbxproj_parser'
require 'tempfile'
require 'tmpdir'
require 'xcodeproj'

class XcodeProjWithoutFolderTest < Minitest::Test

  def setup
    @test_dir = set_up_project_in_temporary_directory
  end

  def teardown
    FileUtils.remove_entry(@test_dir)
  end

  def test_coordinator_without_folders
    generate_and_assert(
      xcodeproj_group: Proc.new { |parser| parser.coordinator_group },
      source_path: "MyProject",
      generator_class: CoordinatorGenerator,
      name: "Cotest",
      expected_files: ["CotestCoordinator.swift"]
    )
  end

  def test_interactor_without_folders
    generate_and_assert(
      xcodeproj_group: Proc.new { |parser| parser.interactor_group },
      source_path: "MyProject",
      generator_class: InteractorGenerator,
      name: "Intest",
      expected_files: [
        "IntestInteractor/IntestInteractor.swift",
        "IntestInteractor/IntestInteractorImplementation.swift"
      ]
    )
  end

  def test_presenter_without_folders
    generate_and_assert(
      xcodeproj_group: Proc.new { |parser| parser.presenter_group },
      source_path: "MyProject",
      generator_class: PresenterGenerator,
      name: "Pretest",
      expected_files: [
        "Pretest/UI/View",
        "Pretest/UI/ViewController/PretestViewController.swift",
        "Pretest/UI/PretestViewContract.swift",
        "Pretest/Presenter/PretestPresenter.swift",
        "Pretest/Presenter/PretestPresenterImplementation.swift",
        "Pretest/Model",
      ]
    )
  end

  def test_repository_data_folders
    generate_and_assert(
      xcodeproj_group: Proc.new { |parser| parser.repository_data_group },
      source_path: "MyProject",
      generator_class: RepositoryGenerator,
      name: "Retest",
      expected_files: ["Retest/RetestRepositoryImplementation.swift"]
    )
  end

  def test_repository_core_folders
    generate_and_assert(
      xcodeproj_group: Proc.new { |parser| parser.repository_core_group },
      source_path: "MyProject",
      generator_class: RepositoryGenerator,
      name: "Retest",
      expected_files: ["Retest/RetestRepository.swift"]
    )
  end

  private

  def setup_parser
    yml_path = File.join(@test_dir, ".ccios.yml")
    File.open(yml_path, "w") do |io|
      io.puts ccios_yml_without_folders_content
    end

    Kernel.silence_warnings do # xcodeproj emit lots of warnings during `rake test` and not in irb
      config = Config.parse yml_path
      parser = PBXProjParser.new(@test_dir, config)
      yield(config, parser)
    end
  end

  def generate_and_assert(xcodeproj_group:, source_path:, generator_class:, name:, expected_files:)
    setup_parser do |config, parser|
      group = xcodeproj_group.call(parser)
      assert_empty group.children, "#{group.display_name} group should not contain anything #{group.children}"

      generator = generator_class.new(parser, config)
      generator.generate(name)

      expected_files.each do |file_name|
        base_name = File.basename(file_name)
        expected_path = File.join(@test_dir, source_path, base_name)
        assert File.exist?(expected_path), "File #{expected_path} does not exist" unless File.extname(base_name).empty?

        refute_nil group[file_name], "Group #{file_name} should exist"
      end
    end
  end

  def set_up_project_in_temporary_directory
    dir = Dir.mktmpdir("ccios-tests", "/tmp")
    project_path = File.join(Dir.pwd, "test", "project")
    FileUtils.copy_entry project_path, dir
    dir
  end

  def ccios_yml_without_folders_content
    <<-eos
app:
  project: MyProject.xcodeproj
  presenter:
    source: MyProject/GroupWithoutFolder
    group: MyProject/GroupWithoutFolder/Presenter
  coordinator:
    source: MyProject/GroupWithoutFolder
    group: MyProject/GroupWithoutFolder/Coordinator

core:
  project: MyProject.xcodeproj
  interactor:
    source: MyProject/GroupWithoutFolder
    group: MyProject/GroupWithoutFolder/Interactor
  repository:
    source: MyProject/GroupWithoutFolder
    group: MyProject/GroupWithoutFolder/Interactor

data:
  project: MyProject.xcodeproj
  repository:
    source: MyProject/GroupWithoutFolder
    group: MyProject/GroupWithoutFolder/Repository
eos
  end
end
