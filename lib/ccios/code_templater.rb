require 'mustache'

class CodeTemplater
  def initialize(options = {})
    @options = options
  end

  def content_for_suffix(prefix, suffix)
    method_name = suffix.underscore + '_content'
    public_send(method_name, prefix) if respond_to? method_name
  end

  def rendered_template(name, options)
    template_file = File.join(File.dirname(__FILE__), "templates/#{name}.mustache")
    Mustache.render(File.read(template_file), options)
  end

  def view_contract_content(name, options = @options)
    options[:name] = name
    rendered_template("view_contract", options)
  end

  def view_controller_content(name, options = @options)
    options[:name] = name
    rendered_template("view_controller", options)
  end

  def presenter_content(name, options = @options)
    options[:name] = name
    rendered_template("presenter", options)
  end

  def presenter_implementation_content(name, options = @options)
    options[:name] = name
    rendered_template("presenter_implementation", options)
  end

  def dependency_provider_content(name, options = @options)
    options[:name] = name
    options[:lowercased_name] = name.camelize(:lower)
    rendered_template("dependency_provider", options)
  end

  def presenter_assembly_content(name, options = @options)
    options[:name] = name
    rendered_template("presenter_assembly", options)
  end

  def coordinator_content(name, options = @options)
    options[:name] = name
    rendered_template("coordinator", options)
  end

  def interactor_content(name, options = @options)
    options[:name] = name
    rendered_template("interactor", options)
  end

  def interactor_implementation_content(name, options = @options)
    options[:name] = name
    rendered_template("interactor_implementation", options)
  end

  def interactor_assembly_content(name, options = @options)
    options[:name] = name
    rendered_template("interactor_assembly", options)
  end

  def repository_content(name, options = @options)
    options[:name] = name
    rendered_template("repository", options)
  end

  def repository_implementation_content(name, options = @options)
    options[:name] = name
    rendered_template("repository_implementation", options)
  end

  def repository_assembly_content(name, options = @options)
    options[:name] = name
    rendered_template("repository_assembly", options)
  end
end
