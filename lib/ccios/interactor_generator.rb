require_relative 'file_creator'
require_relative "pbxproj_parser"

class InteractorGenerator

  def initialize(parser, config)
    @parser = parser
    @config = config
  end

  def generate(interactor_name, options = {})
    interactor_name = interactor_name.gsub("Interactor", "")

    if @parser.interactor_path
      path = @parser.interactor_path
      target_name = @config.core.target

      file_creator = FileCreator.new(options)
      file_creator.create_file_at_path(interactor_name, 'Interactor', path, target_name)
      file_creator.create_file_at_path(interactor_name, 'InteractorImplementation', path, target_name)
    else
      interactor_group = @parser.interactor_group
      new_group_name = "#{interactor_name}Interactor"

      associate_path_to_group = !interactor_group.path.nil?

      raise "[Error] Group #{new_group_name} already exists in #{app_group.display_name}" if interactor_group[new_group_name]
      new_group_path = File.join(interactor_group.real_path, new_group_name)
      new_group = interactor_group.pf_new_group(
        associate_path_to_group: associate_path_to_group,
        name: new_group_name,
        path: new_group_path
      )

      file_creator = FileCreator.new(options)
      target = @parser.core_target
      file_creator.create_file(interactor_name, 'Interactor', new_group, target)
      file_creator.create_file(interactor_name, 'InteractorImplementation', new_group, target)
    end

    file_creator.print_file_content(interactor_name, 'InteractorAssembly')
  end
end
