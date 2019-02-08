lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'tails/version'

Gem::Specification.new do |s|
  s.name        = 'tails'
  s.version     = Tails::VERSION
  s.date        = '2019-01-29'
  s.summary     = "Tails interface"
  s.description = "Tails is an interface that helps on common stuff to connect to our activemq STOMP service"
  s.authors     = ["Gastón L. Rey"]
  s.email       = 'grey@netquest.com'
  s.files       = Dir.glob("lib/**/*")
  s.files       += Dir.glob("helpers/**/*")
  s.files       += Dir.glob("bin/*")
  s.files       += Dir.glob("config/**/*")
  s.files       += Dir.glob("samples/**/*")
  s.files       += Dir.glob("README.md")
  s.executables   = ['tails']
  s.require_paths = ["lib/tails", "lib/tails/helpers", "config"]
  s.homepage      = ""
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.required_ruby_version = '>= 2.6'

  s.add_dependency 'typhoeus'
  s.add_dependency 'require_all'
  s.add_dependency 'stomp'

  s.add_development_dependency 'rspec'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'webmock'
  s.add_development_dependency 'byebug'
  s.add_development_dependency 'rubocop-gemfile'
  s.add_development_dependency 'rubocop-rspec'
end
