require_relative "lib/active_record_simple_execute/version"

require "bundler/gem_tasks"
require "rake/testtask"

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList["test/**/*_test.rb"]
end

task default: [:test]

task :console do
  require 'active_record_simple_execute'

  require 'test/dummy_app/app/models/post'

  require 'irb'
  binding.irb
end
