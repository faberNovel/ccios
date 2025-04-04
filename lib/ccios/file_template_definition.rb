require_relative 'code_templater'
require_relative 'file_creator'
require_relative 'xcode_group_representation'

class FileTemplateDefinition
  def initialize(file_template_definition_hash)
    @name = file_template_definition_hash["name"]
    @path = file_template_definition_hash["file"]
    @template = file_template_definition_hash["template"]
    @variables = file_template_definition_hash["variables"] || {}
  end

  def validate(parser, project, context, template_definition, config)

    merged_variables = config.variables_for_template_element(template_definition, @name, @variables)

    code_templater = CodeTemplater.new
    expected_context_keys = template_definition.provided_context_keys
    pathTags = code_templater.get_unknown_context_keys_for_string(@path)
    pathTags.each do |tag|
      raise "Unknown parameter \"#{tag}\" in path \"#{@path}\"" unless expected_context_keys.include?(tag)
    end

    file_path = code_templater.render_string(@path, context)
    raise "File #{file_path} already exists" if File.exist?(file_path)

    file_creator = FileCreator.new
    contentTags = file_creator.get_unknown_template_tags_for(template_definition.template_source_file(@template))
    contentTags.each do |tag|
      raise "Unknown parameter \"#{tag}\" in template \"#{@template}\"" unless expected_context_keys.include?(tag)
    end

    base_path = merged_variables["base_path"]
    raise "Missing base_path variable" if base_path.nil?

    # base_group = XcodeGroupRepresentation.findGroup(base_path, project)
    # raise "Base path \"#{base_path}\" is missing" if base_group.nil?

    # target_name = merged_variables["target"]
    # if target_name.is_a?(String) || target_name.nil?
    #   target = parser.target_for(project, target_name)
    #   raise "Unable to find target \"#{target_name}\"" if target.nil?
    # elsif target_name.is_a?(Array)
    #   target_name.each do |target_name|
    #     target = parser.target_for(project, target_name)
    #     raise "Unable to find target \"#{target_name}\"" if target.nil?
    #   end
    # else
    #   raise "Invalid target in template #{@name}"
    # end

  end

  def generate(parser, project, context, template_definition, config)
    merged_variables = config.variables_for_template_element(template_definition, @name, @variables)

    base_path = merged_variables["base_path"]
    base_group = XcodeGroupRepresentation.findGroup(base_path, project)
    file_path = CodeTemplater.new.render_string(@path, context)

    intermediates_groups = file_path.split("/")[0...-1]
    generated_filename = file_path.split("/")[-1]

    group = base_group.create_groups_if_needed_for_intermediate_groups(intermediates_groups)

    target_name = merged_variables["target"]

    # targets = []
    # if target_name.is_a?(String) || target_name.nil?
    #   targets = [parser.target_for(project, target_name)]
    # elsif target_name.is_a?(Array)
    #   targets = target_name.map { |name| parser.target_for(project, name) }
    # end

    FileCreator.new.create_file_using_template_path(
      template_definition.template_source_file(@template),
      generated_filename,
      group,
      [],
      # targets,
      project,
      context
    )
  end
end
