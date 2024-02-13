require_relative 'file_creator'

class SnippetTemplateDefinition
  def initialize(snippet_template_definition_hash)
    @name = snippet_template_definition_hash["name"]
    @template = snippet_template_definition_hash["template"]
  end

  def validate(template_definition)
    expected_context_keys = template_definition.provided_context_keys
    file_creator = FileCreator.new
    contentTags = file_creator.get_unknown_template_tags_for(template_definition.template_source_file(@template))
    contentTags.each do |tag|
      raise "Unknown parameter \"#{tag}\" in template \"#{@template}\""  unless expected_context_keys.include?(tag)
    end
  end

  def generate(context, template_definition)

    file_creator = FileCreator.new
    file_creator.print_file_content_using_template(
      @name,
      template_definition.template_source_file(@template),
      context
    )
  end
end
