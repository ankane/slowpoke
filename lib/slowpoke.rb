# dependencies
require "rack/timeout/base"

# modules
require "slowpoke/middleware"
require "slowpoke/railtie"
require "slowpoke/version"

module Slowpoke
  ENV_KEY = "slowpoke.timed_out".freeze
end

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
