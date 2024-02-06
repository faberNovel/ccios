require 'yaml'

class Config

  attr_reader :variables

  def self.parse(source_path)
    if File.exist?(source_path)
      config = YAML.load_file(source_path)
      self.new config, source_path
    else
      puts "File #{source_path} does not exist. Using default config."
      self.default
    end
  end

  def self.default
    self.new default_config_hash
  end

  def self.default_config_hash
    {}
  end

  def initialize(config_hash, source_path = nil)
    @variables = config_hash["variables"] || {}
  end
end
