require 'minitest/autorun'
require_relative '../lib/ccios/templates_loader'
require_relative '../lib/ccios/template_definition'
require_relative '../lib/ccios/config'
require 'xcodeproj'

class TemplatesLoaderTest < Minitest::Test

  def test_default_templates_are_found
    config = Config.default

    templates = TemplatesLoader.new.get_templates(config)

    assert_equal templates.count, 4
    assert templates["coordinator"]
    assert templates["interactor"]
    assert templates["presenter"]
    assert templates["repository"]
  end

  def test_additional_collection_templates_are_found

    config_hash = {}
    config_hash["templates_collection"] = File.join(Dir.pwd, "test", "templates_collections", "additional_templates")
    config = Config.new(config_hash)

    templates = TemplatesLoader.new.get_templates(config)

    assert_equal templates.count, 5
    # Added templates
    assert templates["simple"]
    # Default templates
    assert templates["coordinator"]
    assert templates["interactor"]
    assert templates["presenter"]
    assert templates["repository"]
  end

  def test_additional_collection_templates_overrides_ddefault_templates

    config_hash = {}
    config_hash["templates_collection"] = File.join(Dir.pwd, "test", "templates_collections", "overriding_templates")
    config = Config.new(config_hash)

    templates = TemplatesLoader.new.get_templates(config)

    assert templates["coordinator"]
    overridden_template = templates["coordinator"]
    assert_equal overridden_template.description, "My custom Coordinator template"
  end
end
