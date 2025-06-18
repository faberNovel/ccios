require_relative 'code_templater'
require_relative 'file_creator'

class GroupTemplateDefinition
  def initialize(group_template_definition_hash)
    @name = group_template_definition_hash["name"]
    @path = group_template_definition_hash["group"]
    @template = group_template_definition_hash["path"]
    @variables = group_template_definition_hash["variables"] || {}
  end

  def validate(parser, project, context, template_definition, config)
    merged_variables = config.variables_for_template_element(template_definition, @name, @variables)

    code_templater = CodeTemplater.new
    pathTags = code_templater.get_unknown_context_keys_for_string(@path)
    pathTags.each do |tag|
      raise "Unknown parameter \"#{tag}\" in path \"#{@path}\"" if context[tag].nil?
    end

    base_path = merged_variables["base_path"]
    raise "Missing base_path variable" if base_path.nil?

    base_group = XcodeGroupRepresentation.findGroup(base_path, project)
    raise "Base path \"#{base_path}\" is missing" if base_group.nil?
  end

  def generate(parser, project, context, template_definition, config)
    merged_variables = config.variables_for_template_element(template_definition, @name, @variables)

    base_path = merged_variables["base_path"]
    base_group = XcodeGroupRepresentation.findGroup(base_path, project)
    group_path = CodeTemplater.new.render_string(@path, context)

    group_path_components = group_path.split("/")
    group = base_group.create_groups_if_needed_for_intermediate_groups(group_path_components)

    file_creator = FileCreator.new
    file_creator.create_empty_directory_for_group(group)
  end
end
