require 'mustache'

class CodeTemplater
  def initialize(options = {})
    @options = options
  end

  def content_for_suffix(prefix, suffix)
    template_name = suffix.underscore
    options = @options.merge({name: prefix})
    template_file = File.join(File.dirname(__FILE__), "templates/#{template_name}.mustache")
    Mustache.render(File.read(template_file), options)
  end
end
