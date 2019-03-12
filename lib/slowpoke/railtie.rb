module Slowpoke
  class Railtie < Rails::Railtie
    initializer "slowpoke" do |app|
      if Rails::VERSION::MAJOR >= 5
        app.config.middleware.insert_after ActionDispatch::DebugExceptions, Rack::Timeout,
          service_timeout: Slowpoke.timeout
      else
        app.config.middleware.insert_before ActionDispatch::RemoteIp, Rack::Timeout,
          service_timeout: Slowpoke.timeout
      end
      app.config.middleware.insert(0, Slowpoke::Middleware) unless Rails.env.development? || Rails.env.test?
    end
  end
end
