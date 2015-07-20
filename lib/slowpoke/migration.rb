module Slowpoke
  module Migration
    def connection
      if ENV["MIGRATION_STATEMENT_TIMEOUT"]
        @connection_with_timeout ||= begin
          config = ActiveRecord::Base.connection_config
          config["variables"] ||= {}
          config["variables"]["statement_timeout"] = ENV["MIGRATION_STATEMENT_TIMEOUT"].to_i
          ActiveRecord::Base.establish_connection(config)
          ActiveRecord::Base.connection
        end
      else
        super
      end
    end
  end
end

ActiveRecord::Migration.prepend(Slowpoke::Migration)
