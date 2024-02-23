class ArgumentTemplateParameter
  attr_reader :name, :description, :template_variable_name

  def initialize(parameter_template_definition_hash)
    @name = parameter_template_definition_hash["argument"]
    @description = parameter_template_definition_hash["description"] || ""
    @template_variable_name = parameter_template_definition_hash["template_variable_name"] || @name
    @removeSuffix = parameter_template_definition_hash["removeSuffix"] || ""
    @lowercased_name = parameter_template_definition_hash["lowercased_variable_name"] || ""

    raise "Missing argument name" if @name.nil? || @name.empty?
    raise "Invalid argument template_variable_name for #{@name}" if @template_variable_name.nil? || template_variable_name.empty?
  end

  def update_context(context)
    if !@removeSuffix.empty?
      value = context[@template_variable_name]
      context[@template_variable_name] = value.gsub(@removeSuffix, "")
    end
    if !@lowercased_name.empty? && !context[@lowercased_name]
      context[@lowercased_name] = context[@template_variable_name].camelize(:lower)
    end
    context
  end

  def provided_context_keys
    context_keys = [@template_variable_name]
    if !@lowercased_name.empty?
      context_keys.append(@lowercased_name)
    end
    context_keys
  end
end
