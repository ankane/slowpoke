require_relative "lib/slowpoke/version"

Gem::Specification.new do |spec|
  spec.name          = "slowpoke"
  spec.version       = Slowpoke::VERSION
  spec.summary       = "Rack::Timeout enhancements for Rails"
  spec.homepage      = "https://github.com/ankane/slowpoke"
  spec.license       = "MIT"

  spec.author        = "Andrew Kane"
  spec.email         = "andrew@ankane.org"

  spec.files         = Dir["*.{md,txt}", "{lib}/**/*"]
  spec.require_path  = "lib"

  spec.required_ruby_version = ">= 2.6"

  spec.add_dependency "railties", ">= 5.2"
  spec.add_dependency "actionpack"
  spec.add_dependency "rack-timeout", ">= 0.4"
end
