# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'yequel/version'

Gem::Specification.new do |spec|
  spec.name          = "yequel"
  spec.version       = Yequel::VERSION
  spec.authors       = ["Al Kivi"]
  spec.email         = ["al.kivi@vizi.ca"]

  spec.summary       = %q{Provides a sequel style ORM layer for YAML::Store}
  spec.description   = %q{Yequel provides a sequel style with basic features to access YAML::Store tables.  Its target audience is application developers who require light weight alternative to SQL databases.}
  spec.homepage      = "https://rubygems.org/profiles/vizi_master"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  #if spec.respond_to?(:metadata)
    #spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  #else
    #raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  #end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_runtime_dependency "hash_dot", "~> 2.0"
  spec.add_runtime_dependency "will_paginate", "~> 3.1"

end
