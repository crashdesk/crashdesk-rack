# -*- encoding: utf-8 -*-
require File.expand_path('../lib/crashdesk-rack/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name = 'crashdesk-rack'
  gem.version = CrashdeskRack::VERSION
  gem.authors = ["Ladislav Martincik"]
  gem.summary = "Crashde.sk Rack Integration"
  gem.description = "crashdesk-rack is the Rack gem for integration with crashde.sk servers"
  gem.email = "info@crashde.sk"
  gem.files =  Dir['lib/**/*'] + Dir['spec/**/*'] + Dir['*.rb'] + ["crashdesk-rack.gemspec", "Rakefile"]
  gem.homepage = "http://crashde.sk"
  gem.require_paths = ["lib"]
  gem.rubyforge_project = "crashdesk-rack"
  gem.add_dependency('crashdesk', '~> 0')
  gem.add_dependency('rack', '~> 1.0')
end

