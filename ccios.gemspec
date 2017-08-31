Gem::Specification.new do |s|
  s.name        = 'ccios'
  s.version     = '1.0.3'
  s.executables << 'ccios'
  s.date        = '2016-08-03'
  s.summary     = "Clean Code iOS Generator"
  s.description = "Clean Code iOS Generator"
  s.authors     = ["Pierre Felgines"]
  s.email       = 'pierre.felgines@gmail.com'
  s.files       = ["lib/ccios.rb", "lib/ccios/code_templater.rb", "lib/ccios/file_creator.rb", "lib/ccios/presenter_generator.rb", "lib/ccios/pbxproj_parser.rb", "lib/ccios/templates/view_contract.mustache", "lib/ccios/templates/view_controller.mustache", "lib/ccios/templates/presenter.mustache", "lib/ccios/templates/presenter_implementation.mustache", "lib/ccios/templates/dependency_provider.mustache", "lib/ccios/templates/presenter_assembly.mustache"]
  s.homepage    = 'http://rubygems.org/gems/hola'
  s.license     = 'MIT'
  s.add_dependency 'xcodeproj', '~> 1.4'
  s.add_dependency 'rails', '~> 5.1'
  s.add_dependency "mustache", "~> 1.0"
end
