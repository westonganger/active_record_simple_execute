# ActiveRecord Simple Execute

<a href="https://badge.fury.io/rb/active_record_simple_execute" target="_blank"><img height="21" style='border:0px;height:21px;' border='0' src="https://badge.fury.io/rb/active_record_simple_execute.svg" alt="Gem Version"></a>
<a href='https://github.com/westonganger/active_record_simple_execute/actions' target='_blank'><img src="https://github.com/westonganger/active_record_simple_execute/workflows/Tests/badge.svg" style="max-width:100%;" height='21' style='border:0px;height:21px;' border='0' alt="CI Status"></a>
<a href='https://rubygems.org/gems/active_record_simple_execute' target='_blank'><img height='21' style='border:0px;height:21px;' src='https://ruby-gem-downloads-badge.herokuapp.com/active_record_simple_execute?label=rubygems&type=total&total_label=downloads&color=brightgreen' border='0' alt='RubyGems Downloads' /></a>

Sanitize and Execute your raw SQL queries in ActiveRecord and Rails with a much more intuitive and shortened syntax.

# Comparison

**Simple Execute**
```ruby
results = ActiveRecord::Base.simple_execute(sql_str, company_id: @company.id, @user.id)
```

**Stock ActiveRecord Syntax**
```ruby
sql = ActiveRecord::Base.sanitize_sql_array(
  [
    sql_str, 
    company_id: @company.id,
    user_id: @user.id,
  ]
)

results = ActiveRecord::Base.execute(sql)

results = results || []
```

# Installation

```ruby
gem 'active_record_simple_execute'
```

# Usage

```ruby
### WITHOUT SQL VARIABLES
sql = <<~SQL.squish
  SELECT * 
  FROM orders 
  WHERE orders.foo = 'bar'
SQL

results = ActiveRecord::Base.simple_execute(sql_str)

### WITH sql variables

sql = <<~SQL.squish
  SELECT * 
  FROM orders 
  WHERE orders.company_id = :company_id AND orders.updated_by_user_id = :user_id
SQL

results = ActiveRecord::Base.simple_execute(sql_str, company_id: @company.id, @user.id)
```

## Contributing

For quicker feedback during gem development or debugging feel free to use the provided `rake console` task. It is defined within the [`Rakefile`](./Rakefile).

We test multiple versions of `Rails` using the `appraisal` gem. Please use the following steps to test using `appraisal`.

1. `bundle exec appraisal install`
2. `bundle exec appraisal rake test`

# Credits

Created & Maintained by [Weston Ganger](https://westonganger.com) - [@westonganger](https://github.com/westonganger)
