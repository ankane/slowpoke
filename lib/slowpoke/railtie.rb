module Slowpoke
  class Railtie < Rails::Railtie
    config.slowpoke = ActiveSupport::OrderedOptions.new

    # must happen outside initializer (so it runs earlier)
    config.action_dispatch.rescue_responses.merge!(
      "Rack::Timeout::RequestTimeoutError" => :service_unavailable,
      "Rack::Timeout::RequestExpiryError" => :service_unavailable
    )

    initializer "slowpoke" do |app|
      service_timeout = app.config.slowpoke.timeout
      service_timeout ||= ENV["RACK_TIMEOUT_SERVICE_TIMEOUT"] || ENV["REQUEST_TIMEOUT"] || ENV["TIMEOUT"] || 15

      if service_timeout.respond_to?(:call)
        app.config.middleware.insert_after ActionDispatch::DebugExceptions, Slowpoke::Timeout,
          service_timeout: service_timeout
      else
        app.config.middleware.insert_after ActionDispatch::DebugExceptions, Rack::Timeout,
          service_timeout: service_timeout.to_i
      end

      app.config.middleware.insert(0, Slowpoke::Middleware)
    end
  end
end
