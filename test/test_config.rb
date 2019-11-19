require 'minitest/autorun'
require_relative '../lib/ccios/config'
require 'tempfile'

class ConfigTest < Minitest::Test

  def test_default_config
    config = Config.new "not_existing_file"
    assert_config_is_ok config
  end

  def test_file_config
    tempfile = Tempfile.create do |f|
      f << file_config_content
      f.rewind

      config = Config.new f.path
      assert_config_is_ok config
    end
  end

  private

  def assert_config_is_ok(config)
    refute_nil config

    refute_nil config.app.project
    refute_nil config.app.presenter.source
    refute_nil config.app.presenter.group
    refute_nil config.app.coordinator.source
    refute_nil config.app.coordinator.group

    refute_nil config.core.project
    refute_nil config.core.interactor.source
    refute_nil config.core.interactor.group
    refute_nil config.core.repository.source
    refute_nil config.core.repository.group

    refute_nil config.data.project
    refute_nil config.data.repository.source
    refute_nil config.data.repository.group
  end

  def file_config_content
    <<-eos
app:
  project: CleanCodeDemo.xcodeproj
  presenter:
    source: Classes
    group: Classes/App
  coordinator:
    source: Classes
    group: Classes/Coordinator

core:
  project: CleanCodeDemo.xcodeproj
  interactor:
    source: Classes
    group: Classes/Core/Interactor
  repository:
    source: Classes
    group: Classes/Core/Data

data:
  project: CleanCodeDemo.xcodeproj
  repository:
    source: Classes
    group: Classes/Data
eos
  end
end
