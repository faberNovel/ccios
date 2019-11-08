require 'yaml'

class Config

  attr_reader :app, :core, :data

  def initialize(source_path)
    config = config_hash
    @app = AppConfig.new config["app"]
    @core = CoreConfig.new config["core"]
    @data = DataConfig.new config["data"]
  end

  def file_name
    ".ccios.yml"
  end

  def config_hash
    if File.exists?(file_name)
      config = YAML.load_file(file_name)
      validate config
      config
    else
      puts "File #{file_name} does not exists. Using default config."
      default_config_hash
    end
  end

  def default_config_hash
    project = Dir.glob("*.xcodeproj").first
    raise "Missing xcodeproj file in #{Dir.pwd}" if project.nil?

    source = "Classes"
    {
      "app" => {
        "project" => project,
        "presenter" => {"source" => source, "group" => "Classes/App"},
        "coordinator" => {"source" => source, "group" => "Classes/Coordinator"}
      },
      "core" => {
        "project" => project,
        "interactor" => {"source" => source, "group" => "Classes/Core/Interactor"},
        "repository" => {"source" => source, "group" => "Classes/Core/Data"}
      },
      "data" => {
        "project" => project,
        "repository" => {"source" => source, "group" => "Classes/Data"}
      }
    }
  end

  def validate(hash)
    validate_path hash, "app.project"
    validate_path hash, "app.presenter.source"
    validate_path hash, "app.presenter.group"
    validate_path hash, "app.coordinator.source"
    validate_path hash, "app.coordinator.group"

    validate_path hash, "core.project"
    validate_path hash, "core.interactor.source"
    validate_path hash, "core.interactor.group"
    validate_path hash, "core.repository.source"
    validate_path hash, "core.repository.group"

    validate_path hash, "data.project"
    validate_path hash, "data.repository.source"
    validate_path hash, "data.repository.group"
  end

  def validate_path(hash, path)
    components = path.split(".")
    keys = []
    components.each do |component|
      hash = hash[component]
      keys << component
      raise "Key \"#{keys.join(".")}\" is missing in #{file_name}" if hash.nil?
    end
  end
end

class AppConfig
  attr_reader :project, :presenter, :coordinator

  def initialize(hash)
    @project = hash["project"]
    @presenter = ObjectConfig.new hash["presenter"]
    @coordinator = ObjectConfig.new hash["coordinator"]
  end
end

class CoreConfig
  attr_reader :project, :interactor, :repository

  def initialize(hash)
    @project = hash["project"]
    @interactor = ObjectConfig.new hash["interactor"]
    @repository = ObjectConfig.new hash["repository"]
  end
end

class DataConfig
  attr_reader :project, :repository

  def initialize(hash)
    @project = hash["project"]
    @repository = ObjectConfig.new hash["repository"]
  end
end

class ObjectConfig

  attr_reader :source, :group

  def initialize(hash)
    @source = hash["source"]
    @group = hash["group"]
  end
end
