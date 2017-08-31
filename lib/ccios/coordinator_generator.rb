require_relative 'file_creator'
require_relative "pbxproj_parser"

class CoordinatorGenerator

  def initialize(parser)
    @parser = parser
  end

  def generate(coordinator_name)
    coordinator_group = @parser.coordinator_group
    file_creator = FileCreator.new(@parser.source_path)
    target = @parser.main_target
    file_creator.create_file(coordinator_name, 'Coordinator', coordinator_group, target)
  end
end
