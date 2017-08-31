require 'xcodeproj'

class PBXProjParser

  attr_accessor :source_path, :project

  def initialize(source_path)
    @source_path = source_path
    if project_path.nil?
      raise "[Error] There is no xcodeproj at path #{@source_path}"
    end
    @project = Xcodeproj::Project.open(project_path)
  end

  def project_path
    Dir.glob("#{@source_path}/*.xcodeproj").first
  end

  def main_target
    @project.targets.first
  end

  def classes_group
    @project.groups.find { |g| g.display_name === "Classes" }
  end

  def app_group
    classes_group["App"]
  end

  def core_group
    classes_group["Core"]
  end

  def coordinator_group
    classes_group["Coordinator"]
  end

  def interactor_group
    core_group["Interactor"]
  end

  def data_group
    classes_group["Data"]
  end

  def save
    @project.save
  end
end