require_relative "test_helper"

class TestSlowpoke < Minitest::Test
  def test_database_timeout
    ActiveRecord::Base.establish_connection adapter: "postgresql", database: "slowpoke_test"
    assert_raises(ActiveRecord::StatementInvalid, /canceling statement due to statement timeout/) { ActiveRecord::Base.connection.execute("SELECT pg_sleep(2)") }
  end

  def test_database_timeout_makara
    ActiveRecord::Base.establish_connection adapter: "postgresql_makara", database: "slowpoke_test", makara: {connections: [{role: "master", host: "localhost"}, {host: "localhost"}]}
    assert_raises(ActiveRecord::StatementInvalid, /canceling statement due to statement timeout/) { ActiveRecord::Base.connection.execute("SELECT pg_sleep(2)") }
  end
end
