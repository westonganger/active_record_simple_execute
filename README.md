# ActiveRecord Simple Execute

<a href="https://badge.fury.io/rb/active_record_simple_execute" target="_blank"><img height="21" style='border:0px;height:21px;' border='0' src="https://badge.fury.io/rb/active_record_simple_execute.svg" alt="Gem Version"></a>
<a href='https://github.com/westonganger/active_record_simple_execute/actions' target='_blank'><img src="https://github.com/westonganger/active_record_simple_execute/workflows/Tests/badge.svg" style="max-width:100%;" height='21' style='border:0px;height:21px;' border='0' alt="CI Status"></a>
<a href='https://rubygems.org/gems/active_record_simple_execute' target='_blank'><img height='21' style='border:0px;height:21px;' src='https://img.shields.io/gem/dt/active_record_simple_execute?color=brightgreen&label=Rubygems%20Downloads' border='0' alt='RubyGems Downloads' /></a>

Sanitize and Execute your raw SQL queries in ActiveRecord and Rails with a much more intuitive and shortened syntax.

# Installation

```ruby
gem 'active_record_simple_execute'
```

## Comparison with Plain ActiveRecord

As seen here using `simple_execute` is much easier to remember than all the hoops plain ActiveRecord makes you jump through.

### Using Simple Execute
```ruby
sql_str = <<~SQL.squish
  SELECT * FROM orders
  FROM orders 
  WHERE orders.company_id = :company_id AND orders.updated_by_user_id = :user_id
SQL

records = ActiveRecord::Base.simple_execute(sql_str, company_id: @company.id, user_id: @user.id)
```

### Using Plain ActiveRecord Syntax
```ruby
sql_str = <<~SQL.squish
  SELECT * 
  FROM orders 
  WHERE orders.company_id = :company_id AND orders.updated_by_user_id = :user_id
SQL

### must use send because this method is private is Rails 5.1 only, Public in 5.0 and 5.2
sanitized_sql = ActiveRecord::Base.sanitize_sql_array([sql_str, company_id: @company.id, user_id: @user.id])

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
```

# Contributing

We test multiple versions of `Rails` using the `appraisal` gem. Please use the following steps to test using `appraisal`.

1. `bundle exec appraisal install`
2. `bundle exec appraisal rake test`

For quicker feedback during gem development or debugging feel free to use the provided `rake console` task. It is defined within the [`Rakefile`](./Rakefile).

# Credits

Created & Maintained by [Weston Ganger](https://westonganger.com) - [@westonganger](https://github.com/westonganger)
