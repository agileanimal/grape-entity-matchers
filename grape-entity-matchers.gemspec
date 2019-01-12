$:.push File.expand_path("../lib", __FILE__)
require "grape_entity_matchers/version"

Gem::Specification.new do |s|
  s.name        = "grape-entity-matchers"
  s.version     = GrapeEntityMatchers::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Mark Madsen"]
  s.email       = ["mark@agileanimal.com"]
  s.homepage    = "https://github.com/agileanimal/grape-entity-matchers"
  s.summary     = %q{Shoulda-like matchers for Grape Entity.}
  s.description = %q{Shoulda-like matchers for Grape Entity.}
  s.license     = "MIT"

  s.rubyforge_project = "grape-entity-matchers"

  s.add_runtime_dependency 'grape-entity', '>= 0.5.0'
  s.add_runtime_dependency 'rspec', '>= 3.2.0'


  s.add_development_dependency 'rake'
  s.add_development_dependency 'maruku'
  s.add_development_dependency 'yard'
  s.add_development_dependency 'bundler'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
