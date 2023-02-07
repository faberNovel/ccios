require_relative 'file_creator'
require_relative "pbxproj_parser"

class CoordinatorGenerator

  def initialize(parser, config)
    @parser = parser
    @config = config
  end

  def generate(coordinator_name, options = {})
    file_creator = FileCreator.new(options)
    coordinator_name = coordinator_name.gsub("Coordinator", "")
    if @parser.coordinator_path
      file_creator.create_file_at_path(coordinator_name, 'Coordinator', @parser.coordinator_path, @config.app.target)
    else
      coordinator_group = @parser.coordinator_group
      target = @parser.app_target
      file_creator.create_file(coordinator_name, 'Coordinator', coordinator_group, target)
    end
  end
end
