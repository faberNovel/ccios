require 'minitest/autorun'
require_relative '../lib/ccios/config'
require 'tempfile'

class ConfigTest < Minitest::Test

  def test_default_config
    config = Config.default
    assert_config_is_ok config
  end

  def test_file_config
    Tempfile.create do |f|
      f << file_config_content
      f.rewind

      config = Config.parse f.path
      assert_config_is_ok config
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

  def assert_config_is_ok(config)
    refute_nil config

    refute_nil config.app.project
    refute_nil config.app.presenter.group
    refute_nil config.app.coordinator.group

    refute_nil config.core.project
    refute_nil config.core.interactor.group
    refute_nil config.core.repository.group

    refute_nil config.data.project
    refute_nil config.data.repository.group
  end

  def file_config_content
    <<-eos
app:
  project: MyProject.xcodeproj
  presenter:
    group: Classes/App
  coordinator:
    group: Classes/Coordinator

core:
  project: MyProject.xcodeproj
  interactor:
    group: Classes/Core/Interactor
  repository:
    group: Classes/Core/Data

data:
  project: MyProject.xcodeproj
  repository:
    group: Classes/Data
eos
  end
end
