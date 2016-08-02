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

ActiveSupport.on_load(:active_record) do
  ActiveRecord::Migration.prepend(Slowpoke::Migration)
end
