# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'guard/elixir/version'

Gem::Specification.new do |spec|
  spec.name          = "guard-elixir"
  spec.version       = Guard::Elixir::VERSION
  spec.authors       = ["Patrick Wyatt"]
  spec.email         = ["pat@codeofhonor.com"]
  spec.description   = "Guard::Elixir automatically runs Elixir 'mix' tests"
  spec.summary       = "Guard gem for Elixir language"
  spec.homepage      = "https://github.com/webcoyote/guard-elixir"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
