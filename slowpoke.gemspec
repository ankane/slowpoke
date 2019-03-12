# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "slowpoke/version"

Gem::Specification.new do |spec|
  spec.name          = "slowpoke"
  spec.version       = Slowpoke::VERSION
  spec.authors       = ["Andrew Kane"]
  spec.email         = ["andrew@chartkick.com"]
  spec.summary       = "Rack::Timeout enhancements for Rails"
  spec.homepage      = "https://github.com/ankane/slowpoke"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "railties"
  spec.add_dependency "actionpack"
  spec.add_dependency "rack-timeout", ">= 0.4.0"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
end
