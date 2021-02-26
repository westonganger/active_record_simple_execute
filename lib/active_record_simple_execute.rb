require "active_record"

ActiveRecord::Base.class_eval do

  def self.simple_execute(sql, **sql_vars)
    sql = ActiveRecord::Base.sanitize_sql_array([sql, **sql_vars])

    results = ActiveRecord::Base.execute(sql)

    return results || []
  end

end
