Gem::Specification.new do |s|
  s.name        = 'ccios'
  s.version     = '2.0.3'
  s.executables << 'ccios'
  s.date        = '2016-08-03'
  s.summary     = "Clean Code iOS Generator"
  s.description = "Clean Code iOS Generator"
  s.authors     = ["Pierre Felgines"]
  s.email       = 'pierre.felgines@gmail.com'
  # use `git ls-files -coz -x *.gem` for development
  s.files       = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  s.homepage    = 'http://rubygems.org/gems/hola'
  s.license     = 'MIT'
  s.add_dependency 'xcodeproj', '~> 1.4'
  s.add_dependency 'rails', '~> 5.1'
  s.add_dependency "mustache", "~> 1.0"
end
