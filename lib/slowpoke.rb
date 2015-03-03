require "slowpoke/version"
require "rack-timeout"
require "robustly"
require "slowpoke/controller"
require "slowpoke/postgres"
require "slowpoke/railtie"
require "action_dispatch/middleware/exception_wrapper"
require "action_controller/base"

module Slowpoke
  ENV_KEY = "slowpoke.timed_out".freeze

  class << self
    attr_writer :database_timeout
  end

  def self.timeout
    @timeout ||= (ENV["REQUEST_TIMEOUT"] || ENV["TIMEOUT"] || 15).to_i
  end

  def self.timeout=(timeout)
    timeout = timeout.to_i if timeout.respond_to?(:to_i)
    @timeout = Rack::Timeout.timeout = timeout
  end

  def self.database_timeout
    @database_timeout ||= ENV["DATABASE_TIMEOUT"].to_i if ENV["DATABASE_TIMEOUT"]
  end

end

# custom error page
ActionDispatch::ExceptionWrapper.rescue_responses["Rack::Timeout::RequestTimeoutError"] = :service_unavailable

# remove noisy logger
Rack::Timeout.unregister_state_change_observer(:logger)

# process protection and notifications
Rack::Timeout.register_state_change_observer(:slowpoke) do |env|
  case env[Rack::Timeout::ENV_INFO_KEY].state
  when :timed_out
    env[Slowpoke::ENV_KEY] = true

    # TODO better payload
    ActiveSupport::Notifications.instrument("timeout.slowpoke", {})
  when :completed
    # extremely important
    # protect the process with a restart
    # https://github.com/heroku/rack-timeout/issues/39
    # can't do in timed_out state consistently
    Process.kill("QUIT", Process.pid) if env[Slowpoke::ENV_KEY]
  end
end

# bubble exceptions for error reporting libraries
ActionController::Base.send(:include, Slowpoke::Controller)

if defined?(PG)
  require "active_record/connection_adapters/postgresql_adapter"
  # database timeout
  ActiveRecord::ConnectionAdapters::PostgreSQLAdapter.send(:include, Slowpoke::Postgres)
end
