module Slowpoke
  module Postgres
    extend ActiveSupport::Concern

    included do
      alias_method_chain :configure_connection, :statement_timeout
    end

    def configure_connection_with_statement_timeout
      configure_connection_without_statement_timeout
      safely do
        timeout = Slowpoke.database_timeout || Slowpoke.timeout
        if timeout && !timeout.respond_to?(:call)
          if ActiveRecord::Base.logger
            ActiveRecord::Base.logger.silence do
              execute("SET statement_timeout = #{timeout * 1000}")
            end
          else
            execute("SET statement_timeout = #{timeout * 1000}")
          end
        end
      end
    end
  end
end
