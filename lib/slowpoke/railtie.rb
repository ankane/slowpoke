module Slowpoke
  class Railtie < Rails::Railtie
    initializer "slowpoke" do |app|
      Rack::Timeout.timeout = Slowpoke.timeout

      # prevent RequestExpiryError from killing web server
      app.config.middleware.delete "Rack::Timeout"
      app.config.middleware.insert_before "ActionDispatch::RemoteIp", "Rack::Timeout"
      app.config.middleware.insert 0, Slowpoke::Middleware
    end
  end
end
