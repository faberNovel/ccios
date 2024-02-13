require 'mustache'
require 'active_support/core_ext/string'

class CodeTemplater

  def render_string(template, context)
    Mustache.render(template, context)
  end

  def get_unknown_context_keys_for_string(template)
    stringView = Mustache.new
    stringView.template = template
    tags = stringView.template.tags || []
    tags = tags.map { |t| t.split(".")[-1] }.to_set
    tags
  end

  def render_file_content_from_template(template_path, filename, context)
    filename = File.basename(filename, File.extname(filename))
    context = context.merge({name: filename, lowercased_name: filename.camelize(:lower)})
    Mustache.render(File.read(template_path), context)
  end

  def get_unknown_context_keys_for_template(template_path)
    templateView = Mustache.new
    templateView.template_file = template_path
    tags = (templateView.template.tags || [])
    tags = tags.map { |t| t.split(".")[-1] }.to_set
    tags.subtract(Set["name", "lowercased_name"])
    tags
  end
end
