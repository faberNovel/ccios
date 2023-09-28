require 'yaml'

class Config

  attr_reader :app, :core, :data, :templates

  def self.parse(source_path)
    if File.exist?(source_path)
      config = YAML.load_file(source_path)
      self.new config, source_path
    else
      puts "File #{source_path} does not exist. Using default config."
      self.default
    end
  end

  def self.default_config_hash
    project = "*.xcodeproj"
    {
      "app" => {
        "project" => project,
        "presenter" => {"group" => "Classes/App"},
        "coordinator" => {"group" => "Classes/Coordinator"}
      },
      "core" => {
        "project" => project,
        "interactor" => {"group" => "Classes/Core/Interactor"},
        "repository" => {"group" => "Classes/Core/Data"}
      },
      "data" => {
        "project" => project,
        "repository" => {"group" => "Classes/Data"}
      },
      "templates" => self.default_templates_hash
    }
  end

  def self.default
    self.new default_config_hash
  end

  def self.default_templates_hash
    { "path" => File.join(File.dirname(__FILE__), "templates") }
  end

  def initialize(config_hash, source_path = nil)
    @source_path = source_path
    validate config_hash
    @app = AppConfig.new config_hash["app"]
    @core = CoreConfig.new config_hash["core"]
    @data = DataConfig.new config_hash["data"]
    if config_hash["templates"].nil?
      @templates = TemplatesConfig.new Config.default_templates_hash
    else
      @templates = TemplatesConfig.new config_hash["templates"]
    end
  end

  def validate(hash)
    validate_path hash, "app.project"
    validate_path hash, "app.presenter.group"
    validate_path hash, "app.coordinator.group"

    validate_path hash, "core.project"
    validate_path hash, "core.interactor.group"
    validate_path hash, "core.repository.group"

    validate_path hash, "data.project"
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
  attr_reader :project, :target, :presenter, :coordinator

  def initialize(hash)
    @project = hash["project"]
    @target = hash["target"]
    @presenter = ObjectConfig.new hash["presenter"]
    @coordinator = ObjectConfig.new hash["coordinator"]
  end
end

class CoreConfig
  attr_reader :project, :target, :interactor, :repository

  def initialize(hash)
    @project = hash["project"]
    @target = hash["target"]
    @interactor = ObjectConfig.new hash["interactor"]
    @repository = ObjectConfig.new hash["repository"]
  end
end

class DataConfig
  attr_reader :project, :target, :repository

  def initialize(hash)
    @project = hash["project"]
    @target = hash["target"]
    @repository = ObjectConfig.new hash["repository"]
  end
end

class ObjectConfig
  attr_reader :group

  def initialize(hash)
    @group = hash["group"]
  end
end

class TemplatesConfig
  attr_reader :path

  def initialize(hash)
    @path = hash["path"]
  end
end
