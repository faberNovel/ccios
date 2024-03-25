require 'minitest/autorun'
require_relative '../lib/ccios/config'
require 'tempfile'

class ConfigTest < Minitest::Test

  def test_file_config_with_templates_collection
    Tempfile.create do |f|
      f << file_config_content_templates_collection
      f.rewind

      config = Config.parse f.path
      assert_equal config.templates_collection, "ccios/templates"
    end
  end

  def test_file_not_valid
    Tempfile.create do |f|
      f << "this is not yaml"
      f.rewind

      assert_raises(RuntimeError) {
        Config.parse f.path
      }
    end
  end

  private

  def file_config_content_templates_collection
    <<-eos
templates_collection: ccios/templates
eos
  end

  def file_config_content_with_variables
    <<-eos
variables:
  project: MyProject.xcodeproj

templates_config:
  repository:
    variables: {}
    elements_variables:
      repository:
        base_path: Core/Data
        target: Core
      repository_implementation:
        base_path: "Data"
        target: Data
  presenter:
    variables:
      target: MyProject
      base_path: MyProject/App
eos
  end
end
