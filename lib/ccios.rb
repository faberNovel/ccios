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
    options[:generate_presenter_delegate] = false
  end
  opts.on("-fName", "--full=Name", "Generate NamePresenter, NamePresenterDelegate, NamePresenterImplementation, NameViewContract and NameViewController") do |v|
    options[:presenter] = v
    options[:generate_presenter_delegate] = true
  end
  opts.on("-h", "--help", "Print this help") do
    puts opts
    exit
  end
end.parse!

source_path = Dir.pwd
parser = PBXProjParser.new source_path

exit if options[:presenter].nil?
presenter_name = options[:presenter]
generate_presenter_delegate = options[:generate_presenter_delegate]

presenter_generator = PresenterGenerator.new parser
presenter_generator.generate(presenter_name, generate_presenter_delegate)

parser.save
