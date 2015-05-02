require "bundler/setup"
Bundler.require(:default)
require "minitest/autorun"
require "minitest/pride"
require "rails/all"
require "pg"
require "makara"
require "slowpoke"

ENV["DATABASE_TIMEOUT"] = "1"
