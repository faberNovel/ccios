require_relative 'file_creator'
require_relative "pbxproj_parser"

class PresenterGenerator

  def initialize(parser, config)
    @parser = parser
    @config = config
  end

  def generate(presenter_name, options = {})
    app_group = @parser.presenter_group

    associate_path_to_group = !app_group.path.nil?

    raise "[Error] Group #{presenter_name} already exists in #{app_group.display_name}" if app_group[presenter_name]
    new_group_path = File.join(app_group.real_path, presenter_name)
    new_group = app_group.new_group(presenter_name, associate_path_to_group ? new_group_path : nil)

    ui_group_path = File.join(new_group_path, "UI")
    ui_group = new_group.new_group("UI", associate_path_to_group ? ui_group_path : nil)

    view_group_path = File.join(ui_group_path, "View")
    view_group = ui_group.new_group("View", associate_path_to_group ? view_group_path : nil)

    view_controller_group_path = File.join(ui_group_path, "ViewController")
    view_controller_group = ui_group.new_group("ViewController", associate_path_to_group ? view_controller_group_path : nil)

    presenter_group_path = File.join(new_group_path, "Presenter")
    presenter_group = new_group.new_group("Presenter", associate_path_to_group ? presenter_group_path : nil)

    model_group_path = File.join(new_group_path, "Model")
    model_group = new_group.new_group("Model", associate_path_to_group ? model_group_path : nil)

    file_creator = FileCreator.new(options)
    target = @parser.app_target
    file_creator.create_file(presenter_name, 'ViewContract', ui_group, target)
    file_creator.create_file(presenter_name, 'ViewController', view_controller_group, target)
    file_creator.create_file(presenter_name, 'Presenter', presenter_group, target)
    file_creator.create_file(presenter_name, 'PresenterImplementation', presenter_group, target)
    file_creator.create_empty_directory(model_group)
    file_creator.create_empty_directory(view_group)

    file_creator.print_file_content(presenter_name, 'DependencyProvider')
    file_creator.print_file_content(presenter_name, 'PresenterAssembly')
  end
end
