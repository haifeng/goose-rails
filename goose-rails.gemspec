# -*- encoding: utf-8 -*-
require File.expand_path('../lib/goose-rails/version', __FILE__)
require "goose-rails/version"

Gem::Specification.new do |gem|
  gem.authors       = ["Ted Meeds"]
  gem.email         = ["tmeeds@gmail.com"]
  gem.description   = %q{URL content extractor}
  gem.summary       = %q{Based on jiminoc/goose scala library.}
  gem.homepage      = "https://github.com/smile-network/goose-rails"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "goose-rails"
  gem.require_paths = ["lib"]
  gem.version       = Goose::Rails::VERSION
end
