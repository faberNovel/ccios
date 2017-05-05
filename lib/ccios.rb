require 'date'
require 'xcodeproj'
require 'optparse'
require 'rails' # for underscore method used in code_templater.rb
require 'ccios/presenter_generator'

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: ccios [options]"
  opts.on("-v", "--[no-]verbose", "Run verbosely") do |v|
    options[:verbose] = v
  end
  opts.on("-pName", "--presenter=Name", "Generate NamePresenter, NamePresenterImplementation, NameViewContract and NameViewController") do |v|
    options[:presenter] = v
  end
  opts.on("-h", "--help", "Print this help") do
    puts opts
    exit
  end
end.parse!

source_path = Dir.pwd
project_path = Dir.glob("#{source_path}/*.xcodeproj").first
project = Xcodeproj::Project.open(project_path)

main_target = project.targets.first

classes_group = project.groups.find { |g| g.display_name === "Classes" }
app_group = classes_group["App"]

exit if options[:presenter].nil?
presenter_name = options[:presenter]

presenter_generator = PresenterGenerator.new(classes_group, source_path)
presenter_generator.generate(presenter_name, main_target)

project.save(project_path)
