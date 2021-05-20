require_relative 'lib/active_record_simple_execute/version'

Gem::Specification.new do |s|
  s.name          = "active_record_simple_execute"
  s.version       = ActiveRecordSimpleExecute::VERSION
  s.authors       = ["Weston Ganger"]
  s.email         = ["weston@westonganger.com"]

  s.summary       = "Sanitize and Execute your raw SQL queries in ActiveRecord and Rails with a much more intuitive and shortened syntax."
  s.description   = s.summary
  s.homepage      = "https://github.com/westonganger/active_record_simple_execute"
  s.license       = "MIT"

  s.metadata["source_code_uri"] = s.homepage
  s.metadata["changelog_uri"] = File.join(s.homepage, "blob/master/CHANGELOG.md")

  s.files = Dir.glob("{lib/**/*}") + %w{ LICENSE README.md Rakefile CHANGELOG.md }
  s.test_files  = Dir.glob("{test/**/*}")
  s.require_path = 'lib'

  s.required_ruby_version = Gem::Requirement.new(">= 1.9.3")

  s.add_runtime_dependency "activerecord", ">= 3.2"
  #s.add_runtime_dependency "railties"

  s.add_development_dependency "rake"
  s.add_development_dependency "minitest"
  s.add_development_dependency 'minitest-reporters'
  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'rails'
  s.add_development_dependency 'appraisal'

  if RUBY_VERSION.to_f >= 2.4
    s.add_development_dependency 'warning'
  end
end
