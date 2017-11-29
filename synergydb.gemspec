# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'synergydb/version'

Gem::Specification.new do |spec|
  spec.name          = 'synergydb'
  spec.version       = Synergydb::VERSION
  spec.authors       = ['Benoit Cote-Jodoin']
  spec.email         = ['benoit@bcj.io']

  spec.summary       = 'Experimental key-value, conflict-free database'
  spec.description   = 'Experimental key-value, conflict-free database that rocks'
  spec.homepage      = 'https://github.com/Becojo/synergydb'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.11'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 0.51'
end
