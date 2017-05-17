Gem::Specification.new do |s|
  s.name        = 'ccios'
  s.version     = '1.0.2'
  s.executables << 'ccios'
  s.date        = '2016-08-03'
  s.summary     = "Clean Code iOS Generator"
  s.description = "Clean Code iOS Generator"
  s.authors     = ["Pierre Felgines"]
  s.email       = 'pierre.felgines@gmail.com'
  s.files       = ["lib/ccios.rb", "lib/ccios/code_templater.rb", "lib/ccios/file_creator.rb", "lib/ccios/presenter_generator.rb"]
  s.homepage    = 'http://rubygems.org/gems/hola'
  s.license     = 'MIT'
  s.add_dependency 'xcodeproj', '~> 1.4'
  s.add_dependency 'rails'
end
