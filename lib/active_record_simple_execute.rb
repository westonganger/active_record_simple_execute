require "active_record_simple_execute/version"

require "active_support/lazy_load_hooks"

ActiveSupport.on_load(:active_record) do

  ActiveRecord::ConnectionAdapters::DatabaseStatements.module_eval do
    def simple_execute(sql_str, **sql_vars)
      readonly = sql_str.strip.downcase.start_with?("select ")

      if readonly
        if Rails::VERSION::STRING.to_f >= 7.1
          sanitized_sql = Arel.sql(sql_str, **sql_vars)
        else
          sanitized_sql = ActiveRecord::Base.sanitize_sql_array([sql_str, **sql_vars])
        end
        query_result = select_all(sanitized_sql)
      else
        # Must use sanitize_sql_array, since Arel.sql is not yet compatible with `exec_query` or `execute`, https://github.com/rails/rails/pull/53740

        sanitized_sql = ActiveRecord::Base.sanitize_sql_array([sql_str, **sql_vars])
        query_result = exec_query(sanitized_sql)
      end

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
