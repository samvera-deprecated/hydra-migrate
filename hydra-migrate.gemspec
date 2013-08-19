# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hydra/migrate/version'

Gem::Specification.new do |spec|
  spec.name          = "hydra-migrate"
  spec.version       = Hydra::Migrate::VERSION
  spec.authors       = ["Michael Klein"]
  spec.email         = ["mbklein@gmail.com"]
  spec.description   = %q{Simple migrations for Hydra objects}
  spec.summary       = %q{Simple migrations for Hydra objects}
  spec.homepage      = ""
  spec.license       = "Apache 2"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'active-fedora'
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
