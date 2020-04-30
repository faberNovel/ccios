require 'xcodeproj'

class PBXProjParser

  attr_accessor :source_path

  def initialize(source_path, config)
    @source_path = source_path
    @config = config
    @projects = {}
  end

  def app_project
    project_for(@config.app.project)
  end

  def core_project
    project_for(@config.core.project)
  end

  def data_project
    project_for(@config.data.project)
  end

  def presenter_group
    path = @config.app.presenter.group
    app_project[path]
  end

  def coordinator_group
    path = @config.app.coordinator.group
    app_project[path]
  end

  def interactor_group
    path = @config.core.interactor.group
    core_project[path]
  end

  def repository_core_group
    path = @config.core.repository.group
    core_project[path]
  end

  def repository_data_group
    path = @config.data.repository.group
    data_project[path]
  end

  def app_target
    target_for(app_project, @config.app.target)
  end

  def core_target
    target_for(core_project, @config.core.target)
  end

  def data_target
    target_for(data_project, @config.data.target)
  end

  def save
    app_project.save
    core_project.save
    data_project.save
  end

  private

  def project_for(path)
    module_project_path = File.join(source_path, path)
    resolved_module_project_path = Dir.glob(module_project_path).first
    if !File.exist?(resolved_module_project_path)
      raise "[Error] There is no xcodeproj at path #{module_project_path}"
    end
    @projects[module_project_path] ||= Xcodeproj::Project.open(resolved_module_project_path)
  end

  def target_for(project, target_name)
    if target_name.blank?
      project.targets.find { |t| t.product_type == "com.apple.product-type.application" }
    else
      project.targets.find { |t| t.name == target_name }
    end
  end
end