require 'yaml'

class Config

  attr_reader :app, :core, :data

  def self.parse(source_path)
    if File.exist?(source_path)
      config = YAML.load_file(source_path)
      self.new config, source_path
    else
      puts "File #{source_path} does not exists. Using default config."
      self.default
    end
  end

  def self.default_config_hash
    source = "Classes"
    project = "*.xcodeproj"
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

  def self.default
    self.new default_config_hash
  end

  def initialize(config_hash, source_path = nil)
    @source_path = source_path
    validate config_hash
    @app = AppConfig.new config_hash["app"]
    @core = CoreConfig.new config_hash["core"]
    @data = DataConfig.new config_hash["data"]
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
      if hash.nil?
        message = "Key \"#{keys.join(".")}\" is missing"
        message += " in #{@source_path}" unless @source_path.nil?
        raise message
      end
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
