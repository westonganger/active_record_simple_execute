require "active_record_simple_execute/version"

require "active_support/lazy_load_hooks"

ActiveSupport.on_load(:active_record) do

  ActiveRecord::ConnectionAdapters::DatabaseStatements.module_eval do
    def simple_execute(sql_str, **sql_vars)
      sanitized_sql = ActiveRecord::Base.sanitize_sql_array([sql_str, **sql_vars])

      query_result = exec_query(sanitized_sql)

      records = query_result.to_a

      return records
    end
  end

  ActiveRecord::Base.class_eval do
    def self.simple_execute(sql_str, **sql_vars)
      self.connection.simple_execute(sql_str, **sql_vars)
    end
  end

end
