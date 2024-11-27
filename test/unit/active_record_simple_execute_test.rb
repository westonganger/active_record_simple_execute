require "test_helper"

class ActiveRecordSimpleExecuteTest < ActiveSupport::TestCase

  def setup
  end

  def teardown
  end

  def mysql?
    ENV["DB_GEM"]&.include?("mysql")
  end

  def test_exposes_version
    assert ActiveRecordSimpleExecute::VERSION.is_a?(String)
  end

  def test_no_results
    sql = <<~SQL.squish
      SELECT * FROM posts WHERE posts.title = 'bar'
    SQL

    results = ActiveRecord::Base.connection.simple_execute(sql)

    assert_kind_of Array, results

    assert_empty results
  end

  def test_has_results
    Post.create!(title: "bar")

    sql = <<~SQL.squish
      SELECT * FROM posts WHERE posts.title = 'bar'
    SQL

    results = ActiveRecord::Base.connection.simple_execute(sql)

    assert_kind_of Array, results

    assert_equal 1, results.size

    assert_kind_of Hash, results.first

    assert_equal "bar", results.first["title"]
  end

  def test_with_sql_vars
    Post.create!(title: "bar")

    sql = <<~SQL.squish
      SELECT * FROM posts WHERE posts.title = :title
    SQL

    results = ActiveRecord::Base.connection.simple_execute(sql, title: "bar")

    assert_kind_of Array, results

    assert_equal 1, results.size

    assert_kind_of Hash, results.first

    assert_equal "bar", results.first["title"]
  end

  def test_for_insert_statement
    sql = <<~SQL.squish
      INSERT INTO posts (title, created_at, updated_at)
      VALUES (:title, :created_at, :updated_at)
    SQL

    ActiveRecord::Base.simple_execute(sql, title: "some-new-title", created_at: Time.now, updated_at: Time.now)

    assert_equal Post.where(title: "some-new-title").size, 1
  end

  def test_for_update_statement
    Post.create!(title: "some-old-title")

    sql = <<~SQL.squish
      UPDATE posts
      SET title = :new_title
      WHERE title = :old_title
    SQL

    results = ActiveRecord::Base.simple_execute(sql, old_title: "some-old-title", new_title: "some-new-title")

    assert_equal results, []

    assert_equal Post.where(title: "some-new-title").size, 1
  end

  def test_for_update_statement_with_returning_clause
    if mysql?
      skip "RETURNING clauses are not supported in MySQL"
    end

    Post.create!(title: "some-old-title")

    sql = <<~SQL.squish
      UPDATE posts
      SET title = :new_title
      WHERE title = :old_title
      RETURNING title, content
    SQL

    results = ActiveRecord::Base.simple_execute(sql, old_title: "some-old-title", new_title: "some-new-title")

    assert_equal results.size, 1
    assert_equal results.first["title"], "some-new-title"
    assert_equal results.first.keys.sort, ["title", "content"].sort

    assert_equal Post.where(title: "some-new-title").size, 1
  end

  def test_for_destroy_statement
    Post.create!(title: "bar")

    sql = <<~SQL.squish
      DELETE FROM posts WHERE posts.title = :title
    SQL

    results = ActiveRecord::Base.simple_execute(sql, title: "bar")

    assert_equal results, []

    assert_equal Post.all.size, 0
  end

  def test_for_destroy_statement_with_returning_clause
    if mysql?
      skip "RETURNING clauses are not supported in MySQL"
    end

    Post.create!(title: "bar")

    sql = <<~SQL.squish
      DELETE FROM posts WHERE posts.title = :title
      RETURNING title, content
    SQL

    results = ActiveRecord::Base.simple_execute(sql, title: "bar")

    assert_equal results.size, 1
    assert_equal results.first["title"], "bar"
    assert_equal results.first.keys.sort, ["title", "content"].sort

    assert_equal Post.all.size, 0
  end

  def test_activerecord_base_method
    Post.create!(title: "bar")

    sql = <<~SQL.squish
      SELECT * FROM posts WHERE posts.title = 'bar'
    SQL

    results = ActiveRecord::Base.simple_execute(sql)

    assert_equal 1, results.size
  end

  def test_connection_method
    Post.create!(title: "bar")

    sql = <<~SQL.squish
      SELECT * FROM posts WHERE posts.title = 'bar'
    SQL

    results = ActiveRecord::Base.connection.simple_execute(sql)

    assert_equal 1, results.size
  end

end
