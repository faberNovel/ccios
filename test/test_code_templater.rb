require 'minitest/autorun'
require_relative '../lib/ccios/code_templater'

class CodeTemplaterTest < Minitest::Test
  def test_all_templates
    templates_files.each do |template_path|
      basename = basename_for_path template_path
      generate_delegate = !basename.slice!("_delegate").nil? # Removes _delegate from basename as well

      templates_dir = Config.default.templates.path
      templater = CodeTemplater.new(options(generate_delegate), templates_dir)
      template_content = templater.content_for_suffix("Test", basename)
      assert_equal_content_of_file(template_path, template_content)
    end
  end

  # Private

  def templates_files
    templates_path = File.join(File.dirname(__FILE__), "templates")
    Dir[templates_path + "/*"]
  end

  def basename_for_path(path)
    ext = File.extname path
    File.basename path, ext
  end

  def assert_equal_content_of_file(path, template)
    file = File.open(path, "rb")
    correct_template = file.read
    assert_equal template, correct_template
  end

  def options(generate_delegate)
    {
      project_name: "ProjectName",
      full_username: "Georges Abitbol",
      date: "01/01/1970",
      generate_delegate: generate_delegate,
    }
  end
end
