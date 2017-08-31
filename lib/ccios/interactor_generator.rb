require_relative 'file_creator'
require_relative "pbxproj_parser"

class InteractorGenerator

  def initialize(parser)
    @parser = parser
  end

  def generate(interactor_name)
    interactor_group = @parser.interactor_group
    new_group_name = "#{interactor_name}Interactor"
    raise "[Error] Group #{new_group_name} already exists in #{app_group.display_name}" if interactor_group[new_group_name]
    new_group = interactor_group.new_group(new_group_name)

    file_creator = FileCreator.new(@parser.source_path)
    target = @parser.main_target
    file_creator.create_file(interactor_name, 'Interactor', new_group, target)
    file_creator.create_file(interactor_name, 'InteractorImplementation', new_group, target)

    file_creator.print_file_content(interactor_name, 'InteractorAssembly')
  end
end
