require_relative 'file_creator'
require_relative "pbxproj_parser"

class RepositoryGenerator

  def initialize(parser, config)
    @parser = parser
    @config = config
  end

  def generate(repository_name, options = {})
    core_group = @parser.repository_core_group
    data_group = @parser.repository_data_group
    raise "[Error] Group #{repository_name} already exists in #{core_group.display_name}" if core_group[repository_name]
    core_data_new_group = core_group.new_group(repository_name)

    raise "[Error] Group #{repository_name} already exists in #{data_group.display_name}" if data_group[repository_name]
    data_new_group = data_group.new_group(repository_name)

    path = File.join(@parser.source_path, @config["core"]["repository"]["source"])
    file_creator = FileCreator.new(path, options)
    target = @parser.core_target
    file_creator.create_file(repository_name, 'Repository', core_data_new_group, target)

    path = File.join(@parser.source_path, @config["data"]["repository"]["source"])
    file_creator = FileCreator.new(path, options)
    target = @parser.data_target
    file_creator.create_file(repository_name, 'RepositoryImplementation', data_new_group, target)

    file_creator.print_file_content(repository_name, 'RepositoryAssembly')
  end
end
