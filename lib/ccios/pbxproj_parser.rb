require 'xcodeproj'

class PBXProjParser

  attr_accessor :source_path, :config, :app_project, :core_project, :data_project

  def initialize(source_path, config = {})
    @source_path = source_path
    @config = config
  end

  def app_project
    @app_project ||= project_for("app")
  end

  def core_project
    @core_project ||= project_for("core")
  end

  def data_project
    @data_project ||= project_for("data")
  end

  def project_for(module_name)
    module_project_path = File.join(source_path, @config[module_name]["project"])
    if !File.exists?(module_project_path)
      raise "[Error] There is no xcodeproj at path #{module_project_path}"
    end
    Xcodeproj::Project.open(module_project_path)
  end

  def presenter_group
    path = config["app"]["presenter"]["group"]
    app_project[path]
  end

  def coordinator_group
    path = config["app"]["coordinator"]["group"]
    app_project[path]
  end

  def interactor_group
    path = config["core"]["interactor"]["group"]
    core_project[path]
  end

  def repository_core_group
    path = config["core"]["repository"]["group"]
    core_project[path]
  end

  def repository_data_group
    path = config["data"]["repository"]["group"]
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
end