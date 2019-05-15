module Slowpoke
  class Railtie < Rails::Railtie
    config.slowpoke = ActiveSupport::OrderedOptions.new

    initializer "slowpoke" do |app|
      service_timeout = app.config.slowpoke.timeout
      service_timeout ||= ENV["RACK_TIMEOUT_SERVICE_TIMEOUT"] || ENV["REQUEST_TIMEOUT"] || ENV["TIMEOUT"] || 15
      service_timeout = service_timeout.to_i

      app.config.middleware.insert_after ActionDispatch::DebugExceptions, Rack::Timeout,
        service_timeout: service_timeout

      app.config.middleware.insert(0, Slowpoke::Middleware) unless Rails.env.development? || Rails.env.test?
    end
  end
end
