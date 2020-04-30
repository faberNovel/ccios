require 'minitest/autorun'
require_relative '../lib/ccios/pbxproj_parser'
require 'xcodeproj'

class ParserTest < Minitest::Test

  def test_projects_are_equal
    Kernel.silence_warnings do # xcodeproj emit lots of warnings during `rake test` and not in irb
      dir = File.join(File.dirname(__FILE__), "project")
      config = Config.default
      parser = PBXProjParser.new(dir, config)

      assert parser.app_project.equal? parser.core_project
      assert parser.app_project.equal? parser.data_project
    end
  end

  def test_targets_are_equal
    Kernel.silence_warnings do # xcodeproj emit lots of warnings during `rake test` and not in irb
      dir = File.join(File.dirname(__FILE__), "project")
      config = Config.default
      parser = PBXProjParser.new(dir, config)

      assert parser.app_target.equal? parser.core_target
      assert parser.app_target.equal? parser.data_target
    end
  end

end
