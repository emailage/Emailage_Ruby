# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'emailage/version'

Gem::Specification.new do |spec|
  spec.name          = "emailage"
  spec.version       = Emailage::VERSION
  spec.authors       = ["Emailage DEV Team"]
  spec.email         = ["devit@emailage.com"]

  spec.license       = "MIT"
  spec.summary       = "Emailage API client written in Ruby"
  spec.description   = "Emailage is a Fraud Prevention Solution. This gem implements a client for the Emailage web service."
  spec.homepage      = "https://emailage.com/"
  spec.metadata      = { "source_code_uri" => "https://github.com/emailage/Emailage_Ruby" }

  spec.files         = Dir.glob("lib/**/*") + ["Gemfile", "emailage.gemspec"]
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.6"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec-core", "~> 3.13"
  spec.add_development_dependency "rspec-expectations", "~> 3.13"
  spec.add_development_dependency "rspec-mocks", "~> 3.13"
  spec.add_development_dependency "yard", ">= 0.9.37"
  spec.add_development_dependency "redcarpet", "~> 3.6"

  spec.add_dependency "typhoeus", "~> 1.4"
  spec.add_dependency "uuid", "~> 2.3"
  spec.add_dependency "json", "~> 2.9"
end