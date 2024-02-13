require_relative 'code_templater'
require_relative 'file_creator'
require_relative 'pbxproj_parser'

class FileTemplateDefinition
  def initialize(file_template_definition_hash)
    @base_path = file_template_definition_hash["base_path"]
    @path = file_template_definition_hash["file"]
    @template = file_template_definition_hash["template"]
    @target = file_template_definition_hash["target"]
  end

  def validate(parser, project, context, template_definition)
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

    base_group = project[@base_path]
    raise "Base path \"#{@base_path}\" is missing" if base_group.nil?

    target = parser.target_for(project, @target)
    raise "Unable to find target \"#{@target}\"" if target.nil?
  end

  def generate(parser, project, context, template_definition)
    base_group = project[@base_path]
    file_path = CodeTemplater.new.render_string(@path, context)

    intermediates_groups = file_path.split("/")[0...-1]
    generated_filename = file_path.split("/")[-1]

    group = base_group
    associate_path_to_group = !base_group.path.nil?

    intermediates_groups.each do |group_name|
      new_group_path = File.join(group.real_path, group_name)
      existing_group = group.groups.find { |g| g.display_name == group_name }
      group = existing_group || group.pf_new_group(
        associate_path_to_group: associate_path_to_group,
        name: group_name,
        path: new_group_path
      )
    end

    target = parser.target_for(project, @target)
    FileCreator.new.create_file_using_template_path(
      template_definition.template_source_file(@template),
      generated_filename,
      group,
      target,
      context
    )
  end
end