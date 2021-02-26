require "test_helper"

class ActiveRecordSimpleExecuteTest < ActiveSupport::TestCase

  def setup
  end

  def teardown
  end

  ### TODO
  
  def test_no_results
    sql = <<~SQL.squish
      select * from orders where orders.foo = 'bar'
    SQL

    results = ActiveRecord::Base.simple_execute(sql)

    assert results.is_a?(Array)

    assert_empty results
  end
  
  def test_has_results
    sql = <<~SQL.squish
      select * from orders where orders.foo = 'bar'
    SQL

    results = ActiveRecord::Base.simple_execute(sql)

    assert results.is_a?(Array)

    assert_not_empty results

    assert results.first.is_a?(HashWithIndifferentAccess)

    assert results.first["foo"].present?
  end
  
  def test_with_sql_vars
    sql = <<~SQL.squish
      select * from orders where orders.foo = 'bar'
    SQL

    results = ActiveRecord::Base.simple_execute(sql)

    assert results.is_a?(Array)

    assert_not_empty results

    assert results.first["bar"].present?
  end

end
