# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'checkr/canada/version'

Gem::Specification.new do |spec|
  spec.name          = "checkr-canada"
  spec.version       = Checkr::Canada::VERSION
  spec.authors       = ["palkan"]
  spec.email         = ["dementiev.vm@gmail.com"]

  spec.summary       = "Checkr Canada API client"
  spec.description   = "Checkr Canda API client (https://checkr-canada.api-docs.io/v1/overview)"
  spec.homepage      = "http://github.com/onboardiq/checkr-canada"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "dry-types", "~> 0.10.3"
  spec.add_runtime_dependency "evil-client", "~> 0.3.2"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 3.5"
end
