# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tiddly_blogger/version'

Gem::Specification.new do |spec|
  spec.name          = 'tiddly_blogger'
  spec.version       = TiddlyBlogger::VERSION
  spec.authors       = ['Megan McVey']
  spec.email         = ['shadowradiance@gmail.com']

  spec.summary       = 'Converts Blogger (Google) blogs into TiddlyWikis'
  spec.homepage      = 'https://github.com/ShadowRadiance/TiddlyBlogger'
  spec.license       = 'MIT'

  spec.required_ruby_version = '2.4'

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  message = 'RubyGems 2.0 or newer is required to protect against public gem pushes.'
  raise message unless spec.respond_to?(:metadata)

  spec.metadata['allowed_push_host'] = ''

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rubocop'
end
