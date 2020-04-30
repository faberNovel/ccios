require 'date'
require 'xcodeproj'
require 'optparse'
require 'rails' # for underscore method used in code_templater.rb
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
  opts.on("-pName", "--presenter=Name", "Generate NamePresenter, NamePresenterImplementation, NameViewContract and NameViewController") do |v|
    options[:presenter] = v
  end
  opts.on("-cName", "--coordinator=Name", "Generate NameCoordinator") do |v|
    options[:coordinator] = v
  end
  opts.on("-iName", "--interactor=Name", "Generate NameInteractor and NameInteractorImplementation") do |v|
    options[:interactor] = v
  end
  opts.on("-rName", "--repository=Name", "Generate NameRepository and NameRepositoryImplementation") do |v|
    options[:repository] = v
  end
  opts.on("-d", "--delegate", "Add delegate for curent generation") do |v|
    options[:generate_delegate] = v
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
