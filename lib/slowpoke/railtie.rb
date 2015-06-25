module Slowpoke
  class Railtie < Rails::Railtie
    initializer "slowpoke" do |app|
      Rack::Timeout.timeout = Slowpoke.timeout
      ActiveRecord::Base.logger.class.send(:include, ::LoggerSilence) if ActiveRecord::Base.logger

      # prevent RequestExpiryError from killing web server
      app.config.middleware.delete "Rack::Timeout"
      app.config.middleware.insert_before "ActionDispatch::RemoteIp", "Rack::Timeout"
    end
  end
end
