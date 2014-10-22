module Slowpoke
  class Railtie < Rails::Railtie

    initializer "slowpoke" do
      Slowpoke.timeout = (ENV["TIMEOUT"] || 15).to_i
    end

  end
end
