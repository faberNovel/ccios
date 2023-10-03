require 'mustache'
require 'active_support/core_ext/string'

class CodeTemplater
  def initialize(options = {}, templates_path)
    @options = options
    @templates_path = templates_path
  end

  def content_for_suffix(prefix, suffix)
    template_name = suffix.underscore
    options = @options.merge({name: prefix, lowercased_name: prefix.camelize(:lower)})
    template_file = File.join(@templates_path, "#{template_name}.mustache")
    Mustache.render(File.read(template_file), options)
  end
end
