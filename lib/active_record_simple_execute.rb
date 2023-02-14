require "active_record_simple_execute/version"

require "active_support/lazy_load_hooks"

ActiveSupport.on_load(:active_record) do

  ActiveRecord::Base.class_eval do
    def self.simple_execute(sql_str, **sql_vars)
      ### must use send because this method is private is Rails 5.1 only, Public in 5.0 and 5.2
      sanitized_sql = ActiveRecord::Base.send(:sanitize_sql_array, [sql_str, **sql_vars])

      results = ActiveRecord::Base.connection.execute(sanitized_sql)

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

end
