require_relative 'file_creator'
require_relative "pbxproj_parser"

class RepositoryGenerator

  def initialize(parser)
    @parser = parser
  end

  def generate(repository_name)
    core_group = @parser.core_group
    core_data_group = core_group["Data"]
    data_group = @parser.data_group
    raise "[Error] Group #{repository_name} already exists in #{core_data_group.display_name}" if core_data_group[repository_name]
    core_data_new_group = core_data_group.new_group(repository_name)

    raise "[Error] Group #{repository_name} already exists in #{data_group.display_name}" if data_group[repository_name]
    data_new_group = data_group.new_group(repository_name)

    file_creator = FileCreator.new(@parser.source_path)
    target = @parser.main_target
    file_creator.create_file(repository_name, 'Repository', core_data_new_group, target)
    file_creator.create_file(repository_name, 'RepositoryImplementation', data_new_group, target)

    file_creator.print_file_content(repository_name, 'RepositoryAssembly')
  end
end
