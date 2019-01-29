lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'version'

Gem::Specification.new do |s|
  s.name        = 'tails'
  s.version     = Tails::VERSION
  s.date        = '2019-01-29'
  s.summary     = "Tails interface"
  s.description = "Tails is an interface that helps on common stuff to connect to our activemq STOMP service"
  s.authors     = ["Gastón L. Rey"]
  s.email       = 'grey@netquest.com'
  s.files       = `git ls-files`.split($/)
  s.require_paths = ["lib", "helpers"]
  s.homepage      = ""
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.required_ruby_version = '>= 2.5.3'

  s.add_dependency 'typhoeus'

  s.add_development_dependency 'rspec'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'webmock'
  s.add_development_dependency 'byebug'
  s.add_development_dependency 'rubocop-gemfile'
  s.add_development_dependency 'rubocop-rspec'
end
