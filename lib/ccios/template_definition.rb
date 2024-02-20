require 'yaml'

require_relative 'file_creator'
require_relative 'pbxproj_parser'
require_relative 'argument_template_parameter'
require_relative 'flag_template_parameter'
require_relative 'file_template_definition'
require_relative 'group_template_definition'
require_relative 'snippet_template_definition'

class TemplateDefinition

  attr_reader :name, :description, :template_path, :template_file_source, :parameters, :variables

  def self.parse(template_path)
    template_definition = File.join(template_path, 'template.yml')
    if File.exist?(template_definition)
      template_definition = YAML.load_file(template_definition)
      self.new template_definition, template_path
    else
      puts "Template #{template_path} is invalid: file #{template_definition} not found."
      nil
    end
  end

  def initialize(template_definition_hash, template_path)
    @template_definition_hash = template_definition_hash
    @template_path = template_path

    @name = template_definition_hash["name"]
    @description = template_definition_hash["description"] || ""
    @variables = template_definition_hash["variables"] || {}

    @parameters = template_definition_hash["parameters"].map { |hash|
      next ArgumentTemplateParameter.new(hash) unless hash["argument"].nil?
      next FlagTemplateParameter.new(hash) unless hash["flag"].nil?
    }.compact

    @generated_elements = template_definition_hash["generated_elements"].map { |hash|
      next FileTemplateDefinition.new(hash) unless hash["file"].nil?
      next GroupTemplateDefinition.new(hash) unless hash["group"].nil?
      next nil
    }.compact

    @snippets = template_definition_hash["code_snippets"].map { |hash|
      SnippetTemplateDefinition.new(hash)
    } unless template_definition_hash["code_snippets"].nil?

    @template_file_source = template_definition_hash["template_file_source"] || {}
  end

  def validate(parser, options, config)

    raise "Error: missing name in template" if @name.nil?
    raise "Error: invalid template name" unless @name.is_a? String

    merged_variables = config.variables_for_template(self)
    project_path = merged_variables["project"]

    project = parser.project_for(project_path)
    raise "Error: Unable to find project \"#{project_path}\"" if project.nil?

    @template_file_source.each do |file_template_name, path|
      raise "Missing template source file for \"#{file_template_name}\"" unless File.exist?(self.template_source_file(file_template_name))
    end

    @generated_elements.each do |generated_element|
      generated_element.validate(parser, project, options, self, config)
    end

    @snippets.each do |snippet|
      snippet.validate(self)
    end
  end

  def template_source_file(name)
    raise "Unknown template file #{name}" if @template_file_source[name].nil?
    File.join(@template_path, @template_file_source[name])
  end

  def provided_context_keys
    @parameters.map { |p| p.template_variable_name }.to_set
  end

  def generate(parser, options, config)

    # TODO: Reimplement suffix strip ?
    # interactor_name = "SampleInteractor"
    # interactor_name = interactor_name.gsub("Interactor", "")

    merged_variables = config.variables_for_template(self)
    project_path = merged_variables["project"]

    project = parser.project_for project_path

    @generated_elements.each do |element|
      element.generate(parser, project, options, self, config)
    end

    @snippets.each do |snippet|
      snippet.generate(options, self)
    end
  end

end
