module Slowpoke
  class Railtie < Rails::Railtie
    initializer "slowpoke" do |app|
      Rack::Timeout.timeout = Slowpoke.timeout
      if Rails::VERSION::MAJOR >= 5
        app.config.middleware.insert_after ActionDispatch::DebugExceptions, Rack::Timeout
      else
        app.config.middleware.insert_before ActionDispatch::RemoteIp, Rack::Timeout
      end
      app.config.middleware.insert(0, Slowpoke::Middleware) unless Rails.env.development?
    end
  end
end
