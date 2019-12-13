module Slowpoke
  class Middleware
    def initialize(app)
      @app = app
    end

    def call(env)
      @app.call(env)
    ensure
      # extremely important
      # protect the process with a restart
      # https://github.com/heroku/rack-timeout/issues/39
      # can't do in timed_out state consistently
      Slowpoke.on_timeout.call(env) if env[Slowpoke::ENV_KEY]
    end
  end
end
