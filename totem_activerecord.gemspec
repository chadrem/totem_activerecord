# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'totem_activerecord/version'

Gem::Specification.new do |spec|
  spec.name          = "totem_activerecord"
  spec.version       = TotemActiverecord::VERSION
  spec.authors       = ["Chad Remesch"]
  spec.email         = ["chad@remesch.com"]
  spec.summary       = %q{ActiveRecord add-on for the Totem gem.}
  spec.description   = %q{Add an easy to use ORM to your Totem based applications.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency("totem")
  spec.add_dependency("activerecord")

  spec.add_development_dependency("bundler", "~> 1.5")
  spec.add_development_dependency("rake")
end
