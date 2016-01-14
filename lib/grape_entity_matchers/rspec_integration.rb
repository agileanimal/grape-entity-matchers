require 'rspec'

RSpec.configure do |config|
  require 'grape_entity_matchers/represent_matcher'
  config.include GrapeEntityMatchers::RepresentMatcher
  require 'grape_entity_matchers/document_matcher'
  config.include GrapeEntityMatchers::DocumentMatcher
end
