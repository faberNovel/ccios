require 'minitest/autorun'
require_relative '../lib/ccios/templates_loader'
require_relative '../lib/ccios/file_creator'
require 'tempfile'
require 'tmpdir'

class SwiftPackageTest < Minitest::Test

  def setup
    FileCreator.logger.level = Logger::ERROR
    @test_dir = set_up_project_in_temporary_directory
  end

  def teardown
    FileUtils.remove_entry(@test_dir)
  end

  def test_coordinator_without_folders
    generate_and_assert(
      source_path: "Sources",
      template_name: "coordinator",
      name: "Cotest",
      expected_files: ["App/Coordinator/CotestCoordinator.swift"]
    )
  end

  def test_interactor_without_folders
    generate_and_assert(
      source_path: "Sources",
      template_name: "interactor",
      name: "Intest",
      expected_files: [
        "Core/Interactor/IntestInteractor/IntestInteractor.swift",
        "Core/Interactor/IntestInteractor/IntestInteractorImplementation.swift"
      ]
    )
  end

  def test_presenter_without_folders
    generate_and_assert(
      source_path: "Sources",
      template_name: "presenter",
      name: "Pretest",
      expected_files: [
        "App/Screen/Pretest/UI/View",
        "App/Screen/Pretest/UI/ViewController/PretestViewController.swift",
        "App/Screen/Pretest/UI/PretestViewContract.swift",
        "App/Screen/Pretest/Presenter/PretestPresenter.swift",
        "App/Screen/Pretest/Presenter/PretestPresenterImplementation.swift",
        "App/Screen/Pretest/Model",
      ]
    )
  end

  def test_repository_data_folders
    generate_and_assert(
      source_path: "Sources",
      template_name: "repository",
      name: "Retest",
      expected_files: ["Data/Repository/Retest/RetestRepositoryImplementation.swift"]
    )
  end

  def test_repository_core_folders
    generate_and_assert(
      source_path: "Sources",
      template_name: "repository",
      name: "Retest",
      expected_files: ["Core/Repository/Retest/RetestRepository.swift"]
    )
  end

  private

  def setup_parser
    yml_path = File.join(@test_dir, ".ccios.yml")
    File.open(yml_path, "w") do |io|
      io.puts ccios_yml_swift_package_content
    end

    config = Config.parse yml_path
    yield(config)
  end

  def generate_and_assert(source_path:, template_name:, name:, expected_files:)
    setup_parser do |config|
      template = TemplatesLoader.new.get_templates(config)[template_name]
      raise "Template not found #{template_name}" if template.nil?

      Dir.chdir(@test_dir) do
        template.generate(nil, {"name" => name}, config)

        expected_files.each do |file_name|
          expected_path = File.join(@test_dir, source_path, file_name)
          assert File.exist?(expected_path), "File #{expected_path} does not exist"
        end
      end
    end
  end

  def set_up_project_in_temporary_directory
    dir = Dir.mktmpdir("ccios-tests", "/tmp")
    project_path = File.join(Dir.pwd, "test", "project")
    FileUtils.copy_entry project_path, dir
    dir
  end

  def ccios_yml_swift_package_content
    <<-eos
variables:
  project_type: spm

templates_config:
  repository:
    variables: {}
    elements_variables:
      repository:
        base_path: Sources/Core/Repository
      repository_implementation:
        base_path: Sources/Data/Repository
  presenter:
    variables:
      base_path: Sources/App/Screen
  coordinator:
    variables:
      base_path: Sources/App/Coordinator
  interactor:
    variables:
      base_path: Sources/Core/Interactor
eos
  end
end
