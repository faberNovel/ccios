require_relative 'file_creator'
require_relative "pbxproj_parser"

class CoordinatorGenerator

  def initialize(parser, config)
    @parser = parser
    @config = config
  end

  def generate(coordinator_name, options = {})
    coordinator_group = @parser.coordinator_group
    file_creator = FileCreator.new(options)
    target = @parser.app_target
    coordinator_name = coordinator_name.gsub("Coordinator", "")
    file_creator.create_file(coordinator_name, 'Coordinator', coordinator_group, target)
  end
end
