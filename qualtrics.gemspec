# -*- encoding: utf-8 -*-
require File.expand_path('../lib/qualtrics/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Jamie Ly"]
  gem.email         = ["jamie.ly@gmail.com"]
  gem.description   = %q{Provides easy access to the Qualtrics API}
  gem.summary       = %q{Provides easy access to the Qualtrics API}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "qualtrics"
  gem.require_paths = ["lib"]
  gem.version       = Qualtrics::VERSION

  gem.add_dependency 'rest-client'
  gem.add_dependency 'json'
  gem.add_dependency 'representable'
  gem.add_dependency 'libxml-ruby'

  gem.add_development_dependency 'rspec'
end

