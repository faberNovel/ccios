require_relative 'file_creator'
require_relative "pbxproj_parser"

class CoordinatorGenerator

  def initialize(parser, config)
    @parser = parser
    @config = config
  end

  def generate(coordinator_name, options = {})
    coordinator_group = @parser.coordinator_group
    path = File.join(@parser.source_path, @config.app.coordinator.source)
    file_creator = FileCreator.new(path, options)
    target = @parser.app_target
    file_creator.create_file(coordinator_name, 'Coordinator', coordinator_group, target)
  end
end
