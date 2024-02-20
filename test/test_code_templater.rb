require 'minitest/autorun'
require_relative '../lib/ccios/code_templater'

class CodeTemplaterTest < Minitest::Test

  def test_string_rendering
    result = CodeTemplater.new.render_string(
      string_template_with_one_parameter,
      {value: "42"}
    )
    assert_equal result, "String with parameter: 42."

    result = CodeTemplater.new.render_string(
      string_template_with_multiple_parameter,
      {param1: "param1", param2: "param2"}
    )
    assert_equal result, "String with parameters: param1, param2, param2."
  end

  def test_get_string_template_variables
    result = CodeTemplater.new.get_unknown_context_keys_for_string(string_template_with_one_parameter)
    assert_equal result, ["value"].to_set

    result = CodeTemplater.new.get_unknown_context_keys_for_string(string_template_with_multiple_parameter)
    assert_equal result, ["param1", "param2"].to_set
  end

  def test_render_file_content_from_template
    Tempfile.create do |f|
      f << test_template_content
      f.rewind
      result = CodeTemplater.new.render_file_content_from_template(
        f.path,
        "Sample.swift",
        {
          name: "Sample",
          project_name: "ProjectName",
          full_username: "Georges Abitbol",
          date: "01/01/1970",
          generate_delegate: true
        }
      )
      assert_equal result, test_template_content_expected_result
    end
  end

  private

  def string_template_with_one_parameter
    "String with parameter: {{ value }}."
  end

  def string_template_with_multiple_parameter
    "String with parameters: {{ param1 }}, {{ param2 }}, {{ param2 }}."
  end

  def test_template_content
    <<-eos
//  {{ name }}.swift
//  {{project_name}}
//  Created by {{full_username}} on {{date}}.

{{#generate_delegate}}
// Generated with delegates

{{/generate_delegate}}
class {{ name }} {}
eos
  end

  def test_template_content_expected_result
    <<-eos
//  Sample.swift
//  ProjectName
//  Created by Georges Abitbol on 01/01/1970.

// Generated with delegates

class Sample {}
eos
  end
end
