require File.expand_path('../lib/retries.rb', __FILE__)

# Maintain your gem's version:
require "retries/version"

Gem::Specification.new do |gem|
  gem.authors       = ["Antoine Finkelstein"]
  gem.email         = ["antoine@firmapi.com"]
  gem.description   = %q{Retries is a gem for retrying blocks with randomized exponential backoff.}
  gem.summary       = %q{Retries is a gem for retrying blocks with randomized exponential backoff.}
  gem.homepage      = "https://github.com/firmapi/retries"

  gem.files         = ["lib/retries.rb"]
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "retries"
  gem.require_paths = ["lib"]
  gem.version       = Retries::VERSION

  # For running the tests
  gem.add_development_dependency "minitest", "~> 5.0"
  gem.add_development_dependency "rake", "~> 10.0"
  gem.add_development_dependency "rr", "~> 1.1"

  # For generating the documentation
  gem.add_development_dependency "yard"
  gem.add_development_dependency "redcarpet"
end
