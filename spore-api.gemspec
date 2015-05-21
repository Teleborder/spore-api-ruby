# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'spore/version'

Gem::Specification.new do |spec|
  spec.name          = "spore-api"
  spec.version       = Spore::Version
  spec.authors       = ["Shayan Guha"]
  spec.email         = ["shayan@teleborder.com"]
  spec.description   = "A simple Spore API library."
  spec.summary       = "A simple Spore API library."
  spec.homepage      = "http://spore.sh/"
  spec.license       = "MIT"

  spec.files = %w(LICENSE.md README.md Rakefile spore-api.gemspec)
  spec.files += Dir.glob("lib/**/*.rb")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'faraday', "~> 0.9"
  spec.add_dependency 'faraday_middleware', "~> 0.9"
  spec.add_dependency 'htmlentities', "~> 4.3"
  spec.add_dependency 'multi_json', '~> 1.8'
end
