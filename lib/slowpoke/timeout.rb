module Slowpoke
  class Timeout
    def initialize(app, service_timeout:)
      @app = app
      @service_timeout = service_timeout
      @middleware = {}
    end

    def call(env)
      service_timeout = @service_timeout.call(env)
      if service_timeout
        (@middleware[service_timeout] ||= Rack::Timeout.new(@app, service_timeout: service_timeout)).call(env)
      else
        @app.call(env)
      end
    end
  end
end
