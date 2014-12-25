require File.expand_path('../lib/ibandit/version', __FILE__)

Gem::Specification.new do |gem|
  gem.add_development_dependency 'rspec',           '~> 3.1'
  gem.add_development_dependency 'rspec-its',       '~> 1.1'
  gem.add_development_dependency 'rubocop',         '~> 0.28.0'
  gem.add_development_dependency 'sax-machine',     '~> 1.1'
  gem.add_development_dependency 'nokogiri',        '~> 1.6'

  gem.authors = ['Grey Baker']
  gem.description = 'Construct, deconstruct, and validate IBANs'
  gem.email = ['grey@gocardless.com']
  gem.files = `git ls-files`.split("\n")
  gem.homepage = 'https://github.com/gocardless/ibandit'
  gem.licenses = ['MIT']
  gem.name = 'ibandit'
  gem.require_paths = ['lib']
  gem.summary = 'Ruby library for manipulating and validating IBANs'
  gem.version = Ibandit::VERSION.dup
end
