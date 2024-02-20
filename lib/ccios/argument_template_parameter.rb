class ArgumentTemplateParameter
  attr_reader :name, :description, :template_variable_name

  def initialize(parameter_template_definition_hash)
    @name = parameter_template_definition_hash["argument"]
    @description = parameter_template_definition_hash["description"] || ""
    @template_variable_name = parameter_template_definition_hash["template_variable_name"] || @name
    @removeSuffix = parameter_template_definition_hash["removeSuffix"] || ""

    raise "Missing argument name" if @name.nil? || @name.empty?
    raise "Invalid argument template_variable_name for #{@name}" if @template_variable_name.nil? || template_variable_name.empty?
  end

  def transformed_value(value)
    if !@removeSuffix.empty?
      value = value.gsub(@removeSuffix, "")
    end
    value
  end
end
