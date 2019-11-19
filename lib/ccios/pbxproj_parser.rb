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
    app_project.targets.first
  end

  def core_target
    core_project.targets.first
  end

  def data_target
    data_project.targets.first
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
    if !File.exists?(Dir.glob(module_project_path).first)
      raise "[Error] There is no xcodeproj at path #{module_project_path}"
    end
    @projects[module_project_path] ||= Xcodeproj::Project.open(resolved_module_project_path)
  end
end