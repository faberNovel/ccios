require 'xcodeproj'
require 'active_support/core_ext/object/blank'

class PBXProjParser

  attr_accessor :source_path

  def initialize(source_path, config)
    @source_path = source_path
    @config = config
    @projects = {}
  end

  def save
    @projects.each do |path, value|
        value.save
    end
  end

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