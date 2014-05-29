require 'rake/testtask'
require 'rspec/core/rake_task'


# I'm leaving this here for reference ven though I'm not going
# to use Test::Unit for this gem.
# Use 'rake test' to run the dummy Test::Unit test.
Rake::TestTask.new do |t|
  t.libs << 'test'
end


RSpec::Core::RakeTask.new(:spec)

desc "Run tests"
task :default => [:spec]

