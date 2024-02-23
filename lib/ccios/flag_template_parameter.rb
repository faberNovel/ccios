class FlagTemplateParameter
  attr_reader :name, :short_name, :description, :template_variable_name

  def initialize(parameter_template_definition_hash)
    @name = parameter_template_definition_hash["flag"]
    @short_name = parameter_template_definition_hash["short_name"]
    @description = parameter_template_definition_hash["description"] || ""
    @template_variable_name = parameter_template_definition_hash["template_variable_name"] || @name

    raise "Missing flag name" if @name.nil? || @name.empty?
    raise "Invalid flag template_variable_name for #{@name}" if @template_variable_name.nil? || template_variable_name.empty?
  end

  def provided_context_keys
    [@template_variable_name]
  end
end
