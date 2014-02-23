notification :terminal_notifier

guard 'bundler' do
  watch('Gemfile')
  # Uncomment next line if Gemfile contain `gemspec' command
  # watch(/^.+\.gemspec/)
end

guard :rspec, cmd: 'bundle exec rspec'  do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$})     { |m| "spec/#{m[1]}_spec.rb" }
  watch(%r{^spec/support/shared_versioning_examples.rb$}) { |m| "spec/" }
  watch('spec/spec_helper.rb')  { "spec/" }
end

