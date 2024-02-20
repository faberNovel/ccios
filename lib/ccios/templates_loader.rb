require_relative 'config'
require_relative 'template_definition'

class TemplatesLoader

  def get_templates(config)
    default_template_folder = File.join(File.dirname(__FILE__), "templates")
    default_templates = load_templates_from_collection(default_template_folder)
    custom_templates = []
    if !config.templates_collection.nil?
      custom_templates = load_templates_from_collection(config.templates_collection)
    end
    templates = {}
    all_templates = default_templates + custom_templates
    all_templates.each do |template|
      templates[template.name] = template
    end
    Hash[templates.sort_by{|k,v| k}]
  end

  private

  def load_templates_from_collection(collection_path)
    template_paths = Dir.children(collection_path)
      .map { |name| File.join(collection_path, name) }
      .select { |path| File.directory? path }
    template_paths
      .map { |template_path| TemplateDefinition.parse(template_path) }
      .compact
  end
end
