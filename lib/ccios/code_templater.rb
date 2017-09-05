require 'mustache'
require 'rails'

class CodeTemplater
  def initialize(options = {})
    @options = options
  end

  def content_for_suffix(prefix, suffix)
    template_name = suffix.underscore
    options = @options.merge({name: prefix, lowercased_name: prefix.camelize(:lower)})
    template_file = File.join(File.dirname(__FILE__), "templates/#{template_name}.mustache")
    Mustache.render(File.read(template_file), options)
  end
end
