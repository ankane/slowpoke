module Slowpoke
  class Middleware
    def initialize(app)
      @app = app
    end

    def call(env)
      @app.call(env)
    ensure
      if env[Slowpoke::ENV_KEY]
        # extremely important
        # protect the process with a restart
        # https://github.com/heroku/rack-timeout/issues/39
        # can't do in timed_out state consistently
        if defined?(::PhusionPassenger)
          `passenger-config detach-process #{Process.pid}`
        elsif defined?(::Puma)
          Process.kill("TERM", Process.pid)
        else
          Process.kill("QUIT", Process.pid)
        end
      end
    end
  end
end
