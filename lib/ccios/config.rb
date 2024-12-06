require 'yaml'

class Config

  attr_reader :variables, :templates_collection

  def self.parse(source_path)
    if File.exist?(source_path)
      config = YAML.load_file(source_path)
      raise "Invalid config file" unless config.is_a?(Hash)
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
    @templates_collection = config_hash["templates_collection"] || nil
    @templates_config = {}

    raise "Invalid \"templates_collection\" in config, should be a string" unless @templates_collection.is_a?(String) || @templates_collection.nil?

    templates_config = config_hash["templates_config"] || {}
    raise "Invalid \"templates_config\" in configuration, it should be a dictionary" unless templates_config.is_a?(Hash)
    templates_config.each do |key, hash|
      raise "Invalid template configuration for \"#{key}\"" unless hash.is_a?(Hash)
      template_config = TemplateConfig.new(hash)
      @templates_config[key] = template_config
    end
  end

  def variables_for_template(template)
    template_config = @templates_config[template.name] || TemplateConfig.new({})
    @variables.merge(template.variables).merge(template_config.variables)
  end

  def variables_for_template_element(template, element_name, element_default_variables = {})
    template_config = @templates_config[template.name] || TemplateConfig.new({})
    element_config = template_config.element_configuration_for(element_name)
    template_variables = @variables.merge(template.variables).merge(template_config.variables)
    template_variables.merge(element_default_variables).merge(element_config.variables)
  end
end

class TemplateConfig

  attr_reader :variables

  def initialize(hash)
    @variables = hash["variables"] || {}
    @template_element_config = {}

    elements_variables = hash["elements_variables"] || {}
    raise "Invalid configuration, \"elements_variables\" should be a dictionary" unless elements_variables.is_a?(Hash)
    elements_variables.each do |key, hash|
      raise "Invalid element variable configuration for \"#{key}\"" unless hash.is_a?(Hash)
      @template_element_config[key] = TemplateElementConfig.new(hash)
    end
  end

  def element_configuration_for(element)
    @template_element_config[element] || TemplateConfig.new({})
  end
end

class TemplateElementConfig

  attr_reader :variables

  def initialize(hash)
    @variables = hash
  end
end