module Slowpoke
  class Railtie < Rails::Railtie

    initializer "slowpoke" do
      Rack::Timeout.service_timeout = Slowpoke.timeout
      ActiveRecord::Base.logger.class.send(:include, ::LoggerSilence) if ActiveRecord::Base.logger
    end

  end
end
