require_relative 'code_templater'
require_relative 'file_creator'
require_relative 'pbxproj_parser'

class GroupTemplateDefinition
  def initialize(group_template_definition_hash)
    @base_path = group_template_definition_hash["base_path"]
    @path = group_template_definition_hash["group"]
    @template = group_template_definition_hash["path"]
    @target = group_template_definition_hash["target"]
  end

  def validate(parser, project, context, template_definition)
    code_templater = CodeTemplater.new
    pathTags = code_templater.get_unknown_context_keys_for_string(@path)
    pathTags.each do |tag|
      raise "Unknown parameter \"#{tag}\" in path \"#{@path}\"" if context[tag].nil?
    end

    base_group = project[@base_path]
    raise "Base path \"#{@base_path}\" is missing" if base_group.nil?
  end

  def generate(parser, project, context, template_definition)
    base_group = project[@base_path]
    group_path = CodeTemplater.new.render_string(@path, context)

    group_path = group_path.split("/")

    group = base_group
    associate_path_to_group = !base_group.path.nil?

    group_path.each do |group_name|
      new_group_path = File.join(group.real_path, group_name)
      existing_group = group.groups.find { |g| g.display_name == group_name }
      group = existing_group || group.pf_new_group(
        associate_path_to_group: associate_path_to_group,
        name: group_name,
        path: new_group_path
      )
    end

    file_creator = FileCreator.new
    file_creator.create_empty_directory(group)
  end
end