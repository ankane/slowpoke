require_relative "lib/slowpoke/version"

Gem::Specification.new do |spec|
  spec.name          = "slowpoke"
  spec.version       = Slowpoke::VERSION
  spec.summary       = "Rack::Timeout enhancements for Rails"
  spec.homepage      = "https://github.com/ankane/slowpoke"
  spec.license       = "MIT"

  spec.author        = "Andrew Kane"
  spec.email         = "andrew@chartkick.com"

  spec.files         = Dir["*.{md,txt}", "{lib}/**/*"]
  spec.require_path  = "lib"

  spec.required_ruby_version = ">= 2.4"

  spec.add_dependency "railties", ">= 5"
  spec.add_dependency "actionpack"
  spec.add_dependency "rack-timeout", ">= 0.4.0"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
end
