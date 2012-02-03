# -*- encoding: utf-8 -*-

Gem::Specification.new do |gem|
  gem.authors       = ["Matt Jones", "Tony Schneider"]
  gem.email         = ["matt.jones@edgecase.com", "tony@edgecase.com"]
  gem.description   = %q{Wrap active resource connections with OAuth 1.0}
  gem.summary       = %q{Wrap active resource connections with OAuth 1.0}
  gem.homepage      = "http://sittercity.com"

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "oauth_resource"
  gem.require_paths = ["lib"]
  gem.version       = "0.0.1"

  gem.add_dependency 'simple_oauth'
  gem.add_dependency 'faraday', '>= 0.8.0.rc2'
  gem.add_dependency 'faraday_middleware'
  gem.add_dependency 'activeresource', '>= 3.0.0'
  gem.add_development_dependency 'rspec', '~> 2.7'
end
