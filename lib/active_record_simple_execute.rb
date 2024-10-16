require "active_record_simple_execute/version"

require "active_support/lazy_load_hooks"

ActiveSupport.on_load(:active_record) do

  ActiveRecord::ConnectionAdapters::DatabaseStatements.module_eval do
    def simple_execute(sql_str, **sql_vars)
      sanitized_sql = ActiveRecord::Base.sanitize_sql_array([sql_str, **sql_vars])

      results = self.execute(sanitized_sql)

      if defined?(PG::Result) && results.is_a?(PG::Result)
        records = results.to_a
      elsif defined?(Mysql2::Result) && results.is_a?(Mysql2::Result)
        records = []

        results.each do |row|
          h = {}

          results.fields.each_with_index do |field,i|
            h[field] = row[i]
          end

          records << h
        end
      else
        records = results
      end

      return records
    end
  end

  ActiveRecord::Base.class_eval do
    def self.simple_execute(sql_str, **sql_vars)
      self.connection.simple_execute(sql_str, **sql_vars)
    end
  end

end
