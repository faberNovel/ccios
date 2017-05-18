require_relative 'file_creator'

class PresenterGenerator

  def initialize(classes_group, source_path, generate_presenter_delegate)
    @classes_group = classes_group
    @source_path = source_path
    @generate_presenter_delegate = generate_presenter_delegate
  end

  def generate(presenter_name, target)
    app_group = @classes_group["App"]
    di_group = @classes_group["DI"]
    raise "[Error] Group #{presenter_name} already exists in #{app_group.display_name}" if app_group[presenter_name]
    new_group = app_group.new_group(presenter_name)

    ui_group = new_group.new_group("UI")
    ui_group.new_group("View")
    view_controller_group = ui_group.new_group("ViewController")
    presenter_group = new_group.new_group("Presenter")
    model_group = new_group.new_group("Model")

    file_creator = FileCreator.new(@source_path, @generate_presenter_delegate)
    file_creator.create_file(presenter_name, 'ViewContract', ui_group, target)
    file_creator.create_file(presenter_name, 'ViewController', view_controller_group, target)
    file_creator.create_file(presenter_name, 'Presenter', presenter_group, target)
    file_creator.create_file(presenter_name, 'PresenterImplementation', presenter_group, target)

    file_creator.print_file_content(presenter_name, 'DependencyProvider')
    file_creator.print_file_content(presenter_name, 'PresenterAssembly')
  end
end
