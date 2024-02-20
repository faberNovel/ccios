require 'minitest/autorun'
require_relative '../lib/ccios/pbxproj_parser'
require 'xcodeproj'

class ParserTest < Minitest::Test

  def test_project_query
    dir = File.join(File.dirname(__FILE__), "project")
    config = Config.default
    parser = PBXProjParser.new(dir, config)

    assert parser.project_for("MyProject.xcodeproj")
  end

  def test_target_query
    dir = File.join(File.dirname(__FILE__), "project")
    config = Config.default
    parser = PBXProjParser.new(dir, config)

    project = parser.project_for("MyProject.xcodeproj")
    assert project
    assert parser.target_for(project, "MyProject")
  end

end
