require "test_helper"

class ActiveRecordSimpleExecuteTest < ActiveSupport::TestCase

  def setup
  end

  def teardown
  end

  def test_exposes_version
    assert ActiveRecordSimpleExecute::VERSION.is_a?(String)
  end

  def test_no_results
    sql = <<~SQL.squish
      SELECT * FROM posts WHERE posts.title = 'bar'
    SQL

    results = ActiveRecord::Base.simple_execute(sql)

    assert_kind_of Array, results

    assert_empty results
  end

  def test_has_results
    Post.create!(title: "bar")

    sql = <<~SQL.squish
      SELECT * FROM posts WHERE posts.title = 'bar'
    SQL

    results = ActiveRecord::Base.simple_execute(sql)

    assert_kind_of Array, results

    assert_equal 1, results.size

    assert_kind_of Hash, results.first

    assert_equal "bar", results.first["title"]
  end

  def test_with_sql_kwargs
    Post.create!(title: "bar")

    sql = <<~SQL.squish
      SELECT * FROM posts WHERE posts.title = :title
    SQL

    results = ActiveRecord::Base.simple_execute(sql, title: "bar")

    assert_kind_of Array, results

    assert_equal 1, results.size

    assert_kind_of Hash, results.first

    assert_equal "bar", results.first["title"]
  end

  def test_with_sql_vars
    Post.create!(title: "bar")

    sql = <<~SQL.squish
      SELECT * FROM posts WHERE posts.title = ?
    SQL

    results = ActiveRecord::Base.simple_execute(sql, "bar")

    assert_kind_of Array, results

    assert_equal 1, results.size

    assert_kind_of Hash, results.first

    assert_equal "bar", results.first["title"]
  end

  def test_with_sql_array_kwargs
    Post.create!(title: "bar")

    sql = <<~SQL.squish
      SELECT * FROM posts WHERE posts.title = :title
    SQL

    results = ActiveRecord::Base.simple_execute([sql, { title: "bar" }])

    assert_kind_of Array, results

    assert_equal 1, results.size

    assert_kind_of Hash, results.first

    assert_equal "bar", results.first["title"]
  end

  def test_with_sql_array_vars
    Post.create!(title: "bar")

    sql = <<~SQL.squish
      SELECT * FROM posts WHERE posts.title = ?
    SQL

    results = ActiveRecord::Base.simple_execute([sql, "bar"])

    assert_kind_of Array, results

    assert_equal 1, results.size

    assert_kind_of Hash, results.first

    assert_equal "bar", results.first["title"]
  end
end
