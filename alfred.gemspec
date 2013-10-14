# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'alfred/version'

Gem::Specification.new do |spec|
  spec.name          = "alfred"
  spec.version       = Alfred::VERSION
  spec.authors       = ["Max Trense"]
  spec.email         = ["dev@trense.info"]
  spec.description   = %q{Create Alfred workflows with ease.}
  spec.summary       = %q{Create Alfred [http://alfredapp.com] workflows with ease.}
  spec.homepage      = "http://www.trense.info"
  spec.license       = "Apache 2"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_dependency 'thor', '~> 0.18'
  spec.add_dependency 'plist', '~> 3.1'
end
