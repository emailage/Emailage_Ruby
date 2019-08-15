# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'emailage/version'

Gem::Specification.new do |spec|
  spec.name          = "HornsAndHooves-emailage"
  spec.version       = Emailage::VERSION
  spec.authors       = ["Emailage DEV Team"]
  spec.email         = ["devit@emailage.com"]

  spec.license       = "MIT"
  spec.summary       = "Emailage API client written in Ruby"
  spec.description   = "Emailage is a Fraud Prevention Solution. This gem implements a client for the Emailage web service."
  spec.homepage      = "https://emailage.com/"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec-core", "~> 3.4"
  spec.add_development_dependency "rspec-expectations", "~> 3.4"
  spec.add_development_dependency "rspec-mocks", "~> 3.4"
  spec.add_development_dependency "yard", ">= 0.9.11"
  spec.add_development_dependency "redcarpet", "~> 3.3"

  spec.add_dependency "typhoeus", "~> 1.0"
  spec.add_dependency "uuid", "~> 2.3"
  spec.add_dependency "json", "~> 2.1"
end
