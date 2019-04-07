require "slowpoke/version"
require "rack/timeout/base"
require "slowpoke/middleware"
require "slowpoke/migration"
require "slowpoke/railtie"
require "action_dispatch/middleware/exception_wrapper"
require "action_controller/base"

module Slowpoke
  ENV_KEY = "slowpoke.timed_out".freeze

  def self.migration_statement_timeout
    ENV["MIGRATION_STATEMENT_TIMEOUT"]
  end
end

# custom error page
ActionDispatch::ExceptionWrapper.rescue_responses["Rack::Timeout::RequestTimeoutError"] = :service_unavailable
ActionDispatch::ExceptionWrapper.rescue_responses["Rack::Timeout::RequestExpiryError"] = :service_unavailable

# remove noisy logger
Rack::Timeout.unregister_state_change_observer(:logger)

# process protection and notifications
Rack::Timeout.register_state_change_observer(:slowpoke) do |env|
  if env[Rack::Timeout::ENV_INFO_KEY].state == :timed_out
    env[Slowpoke::ENV_KEY] = true

    # TODO better payload
    ActiveSupport::Notifications.instrument("timeout.slowpoke", {})
  end
end
