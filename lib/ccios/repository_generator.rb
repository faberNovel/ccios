require_relative 'file_creator'
require_relative "pbxproj_parser"

class RepositoryGenerator

  def initialize(parser, config)
    @parser = parser
    @config = config
  end

  def generate(repository_name, options = {})
    repository_name = repository_name.gsub("Repository", "")

    file_creator = FileCreator.new(options)
    if @parser.repository_core_path
      path = File.join(@parser.repository_core_path, repository_name)
      file_creator.create_file_at_path(repository_name, 'Repository', path, @config.core.target)
    else
      core_group = @parser.repository_core_group
      raise "[Error] Group #{repository_name} already exists in #{core_group.display_name}" if core_group[repository_name]
      associate_path_to_group = !core_group.path.nil?
      core_data_new_group_path = File.join(core_group.real_path, repository_name)
      core_data_new_group = core_group.pf_new_group(
        associate_path_to_group: associate_path_to_group,
        name: repository_name,
        path: core_data_new_group_path
      )

      core_target = @parser.core_target
      file_creator.create_file(repository_name, 'Repository', core_data_new_group, core_target)
    end

    file_creator = FileCreator.new(options)
    if @parser.repository_data_path
      path = File.join(@parser.repository_data_path, repository_name)
      file_creator.create_file_at_path(repository_name, 'RepositoryImplementation', path, @config.data.target)
    else
      data_group = @parser.repository_data_group

      raise "[Error] Group #{repository_name} already exists in #{data_group.display_name}" if data_group[repository_name]
      associate_path_to_group = !data_group.path.nil?
      data_new_group_path = File.join(data_group.real_path, repository_name)
      data_new_group = data_group.pf_new_group(
        associate_path_to_group: associate_path_to_group,
        name: repository_name,
        path: data_new_group_path
      )
      data_target = @parser.data_target
      file_creator.create_file(repository_name, 'RepositoryImplementation', data_new_group, data_target)
    end

    file_creator.print_file_content(repository_name, 'RepositoryAssembly')
  end
end
