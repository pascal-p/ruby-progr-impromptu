# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'lc_doublet/version'

Gem::Specification.new do |spec|
  spec.name          = "lc_doublet"
  spec.version       = LcDoublet::VERSION
  spec.authors       = ["Pascal P"]
  spec.email         = ["lacsap_666@yahoo.fr"]

  spec.summary       = %q{LC doublet or word ladder implementation in Ruby.}
  spec.description   = %q{LC doublet or word ladder implementation in Ruby, using BFS strategy.}
  spec.homepage      = "https://github.com/pascal-p"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.11.2"
  spec.add_development_dependency "rake", "~> 11.1.2"
  spec.add_development_dependency 'rspec-rails', '~> 3.4', '>= 3.4.2'
end
