module Slowpoke
  class Railtie < Rails::Railtie

    initializer "slowpoke" do
      Slowpoke.timeout = (ENV["TIMEOUT"] || 15).to_i
      ActiveRecord::Base.logger.class.send(:include, ::LoggerSilence) if ActiveRecord::Base.logger
    end

  end
end
