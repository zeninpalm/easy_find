require "bundler"
Bundler.setup

require "rake"
require "rspec/core/rake_task"

$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
require "easy_find/version"

task :gem => :build
task :build do
  system "gem build easy_find.gemspec"
end

task :install => :build do
  system "sudo gem install easy_find-#{EasyFind::VERSION}.gem"
end

task :release => :build do
  system "git tag -a v#{EasyFind::VERSION} -m 'Tagging #{EasyFind::VERSION}'"
  system "git push --tags"
  system "gem push EasyFind-#{EasyFind::VERSION}.gem"
  system "rm EasyFind-#{EasyFind::VERSION}.gem"
end

RSpec::Core::RakeTask.new("spec") do |spec|
  spec.pattern = "spec/**/*_spec.rb"
end

task :default => :spec
