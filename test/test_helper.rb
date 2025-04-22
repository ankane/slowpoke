require "bundler/setup"
require "combustion"
Bundler.require(:default)
require "minitest/autorun"
require "minitest/pride"

logger = ActiveSupport::Logger.new(ENV["VERBOSE"] ? STDOUT : nil)

Combustion.path = "test/internal"
Combustion.initialize! :action_controller do
  config.load_defaults Rails::VERSION::STRING.to_f
  config.action_controller.logger = logger

  config.action_dispatch.show_exceptions = Rails.version.to_f >= 7.1 ? :all : true
  config.consider_all_requests_local = false

  config.slowpoke.timeout = lambda do |env|
    request = Rack::Request.new(env)
    request.path.start_with?("/admin") ? 1 : 0.1
  end
end

# https://github.com/rails/rails/issues/54595
if RUBY_ENGINE == "jruby" && Rails::VERSION::MAJOR >= 8
  Rails.application.reload_routes_unless_loaded
end
