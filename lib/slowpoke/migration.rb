module Slowpoke
  module Migration
    def connection
      connection = super
      if Slowpoke.migration_statement_timeout && !@migration_statement_timeout_set
        connection.execute("SET statement_timeout = #{Slowpoke.migration_statement_timeout.to_i}")
        @migration_statement_timeout_set = true
      end
      connection
    end
  end
end

ActiveSupport.on_load(:active_record) do
  ActiveRecord::Migration.prepend(Slowpoke::Migration)
end
