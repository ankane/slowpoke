# dependencies
require "rack/timeout/base"

# modules
require "slowpoke/middleware"
require "slowpoke/railtie"
require "slowpoke/timeout"
require "slowpoke/version"

module Slowpoke
  ENV_KEY = "slowpoke.timed_out".freeze

  def self.kill
    if defined?(::PhusionPassenger)
      `passenger-config detach-process #{Process.pid}`
    elsif defined?(::Puma)
      Process.kill("TERM", Process.pid)
    else
      Process.kill("QUIT", Process.pid)
    end
  end
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
