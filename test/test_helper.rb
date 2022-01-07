#$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
ENV["RAILS_ENV"] = "test"

require "active_record_simple_execute"

### Instantiates Rails
require File.expand_path("../dummy_app/config/environment.rb",  __FILE__)

require "rails/test_help"

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all
end

Rails.backtrace_cleaner.remove_silencers!

require 'minitest/reporters'
Minitest::Reporters.use!(
  Minitest::Reporters::DefaultReporter.new,
  ENV,
  Minitest.backtrace_filter
)

require "minitest/autorun"

############################################################### MIGRATIONS AND DATA
if ActiveRecord.gem_version >= Gem::Version.new("6.0")
  ActiveRecord::MigrationContext.new(File.expand_path("dummy_app/db/migrate/", __dir__), ActiveRecord::SchemaMigration).migrate
elsif ActiveRecord.gem_version >= Gem::Version.new("5.2")
  ActiveRecord::MigrationContext.new(File.expand_path("dummy_app/db/migrate/", __dir__)).migrate
else
  ActiveRecord::Migrator.migrate File.expand_path("dummy_app/db/migrate/", __dir__)
end

[Post].each do |klass|
  if klass.connection.adapter_name.downcase.include?('sqlite')
    ActiveRecord::Base.connection.execute("DELETE FROM #{klass.table_name};")
    ActiveRecord::Base.connection.execute("UPDATE `sqlite_sequence` SET `seq` = 0 WHERE `name` = '#{klass.table_name}';")
  else
    ActiveRecord::Base.connection.execute("TRUNCATE TABLE #{klass.table_name}")
  end
end
