require 'rspec'

RSpec.configure do |config|
  require 'grape_entity_matchers/represent_matcher'
  config.include GrapeEntityMatchers::RepresentMatcher
end