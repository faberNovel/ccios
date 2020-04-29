require_relative 'file_creator'
require_relative "pbxproj_parser"

class PresenterGenerator

  def initialize(parser, config)
    @parser = parser
    @config = config
  end

  def generate(presenter_name, options = {})
    app_group = @parser.presenter_group

    path = File.join(@parser.source_path, @config.app.presenter.source)

    raise "[Error] Group #{presenter_name} already exists in #{app_group.display_name}" if app_group[presenter_name]
    new_group_path = File.join(path, presenter_name)
    new_group = app_group.new_group(presenter_name, new_group_path)

    ui_group_path = File.join(new_group_path, "UI")
    ui_group = new_group.new_group("UI", ui_group_path)

    view_group_path = File.join(ui_group_path, "View")
    view_group = ui_group.new_group("View", view_group_path)

    view_controller_group_path = File.join(ui_group_path, "ViewController")
    view_controller_group = ui_group.new_group("ViewController", view_controller_group_path)

    presenter_group_path = File.join(new_group_path, "Presenter")
    presenter_group = new_group.new_group("Presenter", presenter_group_path)

    model_group_path = File.join(new_group_path, "Model")
    model_group = new_group.new_group("Model", model_group_path)

    file_creator = FileCreator.new(path, options)
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
