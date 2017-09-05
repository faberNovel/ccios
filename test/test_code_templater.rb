require 'minitest/autorun'
require_relative '../lib/ccios/code_templater'

class CodeTemplaterTest < Minitest::Test
  def test_dependency_provider
    templater = CodeTemplater.new(options)
    template = templater.content_for_suffix("Test", "DependencyProvider")
    assert_equal_content_of_file("dependency_provider.swift", template)
  end

  def test_dependency_provider_delegate
    templater = CodeTemplater.new(options_with_delegate)
    template = templater.content_for_suffix("Test", "DependencyProvider")
    assert_equal_content_of_file("dependency_provider_delegate.swift", template)
  end

  def test_presenter_assembly
    templater = CodeTemplater.new(options)
    template = templater.content_for_suffix("Test", "PresenterAssembly")
    assert_equal_content_of_file("presenter_assembly.swift", template)
  end

  def test_presenter_assembly_delegate
    templater = CodeTemplater.new(options_with_delegate)
    template = templater.content_for_suffix("Test", "PresenterAssembly")
    assert_equal_content_of_file("presenter_assembly_delegate.swift", template)
  end

  def test_presenter
    templater = CodeTemplater.new(options)
    template = templater.content_for_suffix("Test", "Presenter")
    assert_equal_content_of_file("presenter.swift", template)
  end

  def test_presenter_delegate
    templater = CodeTemplater.new(options_with_delegate)
    template = templater.content_for_suffix("Test", "Presenter")
    assert_equal_content_of_file("presenter_delegate.swift", template)
  end

  def test_presenter_implementation
    templater = CodeTemplater.new(options)
    template = templater.content_for_suffix("Test", "PresenterImplementation")
    assert_equal_content_of_file("presenter_implementation.swift", template)
  end

  def test_presenter_implementation_delegate
    templater = CodeTemplater.new(options_with_delegate)
    template = templater.content_for_suffix("Test", "PresenterImplementation")
    assert_equal_content_of_file("presenter_implementation_delegate.swift", template)
  end

  def test_view_contract
    templater = CodeTemplater.new(options)
    template = templater.content_for_suffix("Test", "ViewContract")
    assert_equal_content_of_file("view_contract.swift", template)
  end

  def test_view_contract_delegate
    templater = CodeTemplater.new(options_with_delegate)
    template = templater.content_for_suffix("Test", "ViewContract")
    assert_equal_content_of_file("view_contract.swift", template)
  end

  def test_view_controller
    templater = CodeTemplater.new(options)
    template = templater.content_for_suffix("Test", "ViewController")
    assert_equal_content_of_file("view_controller.swift", template)
  end

  def test_view_controller_delegate
    templater = CodeTemplater.new(options_with_delegate)
    template = templater.content_for_suffix("Test", "ViewController")
    assert_equal_content_of_file("view_controller.swift", template)
  end

  def test_interactor
    templater = CodeTemplater.new(options)
    template = templater.content_for_suffix("Test", "Interactor")
    assert_equal_content_of_file("interactor.swift", template)
  end

  def test_interactor_implementation
    templater = CodeTemplater.new(options)
    template = templater.content_for_suffix("Test", "InteractorImplementation")
    assert_equal_content_of_file("interactor_implementation.swift", template)
  end

  def test_interactor_assembly
    templater = CodeTemplater.new(options)
    template = templater.content_for_suffix("Test", "InteractorAssembly")
    assert_equal_content_of_file("interactor_assembly.swift", template)
  end

  def test_repository
    templater = CodeTemplater.new(options)
    template = templater.content_for_suffix("Test", "Repository")
    assert_equal_content_of_file("repository.swift", template)
  end

  def test_repository_implementation
    templater = CodeTemplater.new(options)
    template = templater.content_for_suffix("Test", "RepositoryImplementation")
    assert_equal_content_of_file("repository_implementation.swift", template)
  end

  def test_repository_assembly
    templater = CodeTemplater.new(options)
    template = templater.content_for_suffix("Test", "RepositoryAssembly")
    assert_equal_content_of_file("repository_assembly.swift", template)
  end

  def test_coordinator
    templater = CodeTemplater.new(options)
    template = templater.content_for_suffix("Test", "Coordinator")
    assert_equal_content_of_file("coordinator.swift", template)
  end

  def test_coordinator_delegate
    templater = CodeTemplater.new(options_with_delegate)
    template = templater.content_for_suffix("Test", "Coordinator")
    assert_equal_content_of_file("coordinator_delegate.swift", template)
  end

  # Private

  def assert_equal_content_of_file(name, template)
    path = File.join(File.dirname(__FILE__), "templates/#{name}")
    file = File.open(path, "rb")
    correct_template = file.read
    assert_equal template, correct_template
  end

  def options
    {
      project_name: "ProjectName",
      full_username: "Georges Abitbol",
      date: "01/01/1970",
    }
  end

  def options_with_delegate
    options.merge({generate_delegate: true})
  end
end
