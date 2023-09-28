require 'date'
require 'xcodeproj'
require 'optparse'
require 'active_support'
require 'ccios/presenter_generator'
require 'ccios/coordinator_generator'
require 'ccios/interactor_generator'
require 'ccios/repository_generator'
require 'ccios/config'

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: ccios [options]"
  opts.on("-v", "--[no-]verbose", "Run verbosely") do |v|
    options[:verbose] = v
  end
  opts.on("-pName", "--presenter=Name", "Generate NamePresenter, NamePresenterImplementation, NameViewContract and NameViewController") do |name|
    options[:presenter] = name
  end
  opts.on("-cName", "--coordinator=Name", "Generate NameCoordinator") do |name|
    options[:coordinator] = name
  end
  opts.on("-iName", "--interactor=Name", "Generate NameInteractor and NameInteractorImplementation") do |name|
    options[:interactor] = name
  end
  opts.on("-rName", "--repository=Name", "Generate NameRepository and NameRepositoryImplementation") do |name|
    options[:repository] = name
  end
  opts.on("-d", "--delegate", "Add delegate for curent generation") do |add_delegate|
    options[:generate_delegate] = add_delegate
  end
  opts.on("-h", "--help", "Print this help") do
    puts opts
    exit
  end
end.parse!

source_path = Dir.pwd
config = Config.parse ".ccios.yml"
parser = PBXProjParser.new(source_path, config)

if options[:presenter]
  presenter_name = options[:presenter]
  presenter_generator = PresenterGenerator.new(parser, config)
  generator_options = {generate_delegate: options[:generate_delegate]}
  presenter_generator.generate(presenter_name, generator_options)
end

if options[:coordinator]
  coordinator_name = options[:coordinator]
  coordinator_generator = CoordinatorGenerator.new(parser, config)
  generator_options = {generate_delegate: options[:generate_delegate]}
  coordinator_generator.generate(coordinator_name, generator_options)
end

if options[:interactor]
  interactor_name = options[:interactor]
  interactor_generator = InteractorGenerator.new(parser, config)
  interactor_generator.generate(interactor_name)
end

if options[:repository]
  repository_name = options[:repository]
  repository_generator = RepositoryGenerator.new(parser, config)
  repository_generator.generate(repository_name)
end

parser.save
