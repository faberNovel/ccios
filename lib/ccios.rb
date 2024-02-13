require 'date'
require 'xcodeproj'
require 'optparse'
require 'active_support'
require 'ccios/config'
require 'ccios/template_definition'

config = Config.parse ".ccios.yml"
source_path = Dir.pwd

default_template_folder = File.join(File.dirname(__FILE__), "ccios", "templates")
default_templates = Dir.children(default_template_folder)
    .map { |name| File.join(default_template_folder, name) }
    .select { |path| File.directory? path }
    .map { |template_path| TemplateDefinition.parse(template_path) }
    .compact

templates = {}
subcommands = {}

options = {}

default_templates.each do |template|
  templates[template.name] = template
  subcommands[template.name] = OptionParser.new do |opts|

    arguments = template.parameters.select { |p| p.is_a?(ArgumentTemplateParameter) }
    flags = template.parameters.select { |p| p.is_a?(FlagTemplateParameter) }

    arguments_line = arguments.map { |argument| "<#{argument.name}>" }.join(" ")

    opts.banner = "Usage: ccios #{template.name} <name> [options]"

    flags.each do |flagParameter|
      if flagParameter.short_name != nil
        opts.on("-#{flagParameter.short_name}", "--#{flagParameter.name}", flagParameter.description) do |v|
          options[flagParameter.template_variable_name] = v
        end
      else
        opts.on("--#{flagParameter.name}", flagParameter.description) do |v|
          options[flagParameter.template_variable_name] = v
        end
      end
    end
  end
end

global_cli = OptionParser.new do |opts|
  opts.banner = "Usage: ccios <template> [options]"
  opts.on("-v", "--[no-]verbose", "Run verbosely") do |v|
    options[:verbose] = v
  end
  opts.on("-h", "--help", "Print this help") do
    puts opts
    puts "Available templates: #{subcommands.keys.sort.join(", ")}"
    exit
  end
end

global_cli.order!
template_name = ARGV.shift

if template_name.nil?
  puts "Error: Missing template name"
  puts global_cli
  exit(1)
end

if subcommands[template_name].nil?
  puts "Error: Unknown template \"#{template_name}\""
  puts global_cli
  exit(1)
end

template = templates[template_name]
expected_remaining_arguments = template.parameters.select { |p| p.is_a?(ArgumentTemplateParameter) }

subcommands[template_name].order! do |argument|
  expected_argument = expected_remaining_arguments.shift
  if expected_argument.nil?
    puts "Unexpected argument: #{argument}"
    exit 1
  end
  options[expected_argument.name] = argument
end

if !expected_remaining_arguments.empty?
  puts "Missing arguments: #{expected_remaining_arguments.map { |p| p.name }.join(", ")}"
  exit 1
end

# TODO: use template.project
parser = PBXProjParser.new(source_path, config)

template.validate(parser, options)
template.generate(parser, options)

parser.save
