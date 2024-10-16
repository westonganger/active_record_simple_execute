# ActiveRecord Simple Execute

<a href="https://badge.fury.io/rb/active_record_simple_execute" target="_blank"><img height="21" style='border:0px;height:21px;' border='0' src="https://badge.fury.io/rb/active_record_simple_execute.svg" alt="Gem Version"></a>
<a href='https://github.com/westonganger/active_record_simple_execute/actions' target='_blank'><img src="https://github.com/westonganger/active_record_simple_execute/actions/workflows/test.yml/badge.svg?branch=master" style="max-width:100%;" height='21' style='border:0px;height:21px;' border='0' alt="CI Status"></a>
<a href='https://rubygems.org/gems/active_record_simple_execute' target='_blank'><img height='21' style='border:0px;height:21px;' src='https://img.shields.io/gem/dt/active_record_simple_execute?color=brightgreen&label=Rubygems%20Downloads' border='0' alt='RubyGems Downloads' /></a>

Sanitize and Execute your raw SQL queries in ActiveRecord and Rails with a much more intuitive and shortened syntax.

# Installation

```ruby
gem "active_record_simple_execute"
```

## Comparison with Plain ActiveRecord

As seen here using `simple_execute` is much easier to remember than all the hoops plain ActiveRecord makes you jump through.

### Using `simple_execute`
```ruby
sql_str = <<~SQL.squish
  SELECT * FROM orders
  FROM orders
  WHERE orders.company_id = :company_id AND orders.updated_by_user_id = :user_id
SQL

records = ActiveRecord::Base.connection.simple_execute(sql_str, company_id: @company.id, user_id: @user.id)
# OR use the convenience method excluding the connection portion
# ActiveRecord::Base.simple_execute(...)
```

### Using original ActiveRecord `exec_query` method
```ruby
sql_str = <<~SQL.squish
  SELECT *
  FROM orders
  WHERE orders.company_id = :company_id AND orders.updated_by_user_id = :user_id
SQL

sanitized_sql = ActiveRecord::Base.sanitize_sql_array([sql_str, company_id: @company.id, user_id: @user.id])

result = ActiveRecord::Base.connection.exec_query(sanitized_sql)

records = result.to_a

return records
```

### Using original ActiveRecord `execute` method
```ruby
sql_str = <<~SQL.squish
  SELECT *
  FROM orders
  WHERE orders.company_id = :company_id AND orders.updated_by_user_id = :user_id
SQL

sanitized_sql = ActiveRecord::Base.sanitize_sql_array([sql_str, company_id: @company.id, user_id: @user.id])

result = ActiveRecord::Base.connection.execute(sanitized_sql)
# OR
result = ActiveRecord::Base.connection.exec_query(sanitized_sql)

if defined?(PG::Result) && result.is_a?(PG::Result)
  records = result.to_a

  result.clear # to prevent memory leak

elsif defined?(Mysql2::Result) && result.is_a?(Mysql2::Result)
  records = []

  result.each do |row|
    h = {}

    result.fields.each_with_index do |field,i|
      h[field] = row[i]
    end

    records << h
  end

else
  records = result
end

return records
```

# Testing

```
bundle exec rake test
```

We can locally test different versions of Rails using `ENV['RAILS_VERSION']`

```
export RAILS_VERSION=7.0
bundle install
bundle exec rake test
```

For quicker feedback during gem development or debugging feel free to use the provided `rake console` task. It is defined within the [`Rakefile`](./Rakefile).

# Credits

Created & Maintained by [Weston Ganger](https://westonganger.com) - [@westonganger](https://github.com/westonganger)
