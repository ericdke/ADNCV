# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ADNCV/version'

Gem::Specification.new do |spec|
  spec.name          = "adncv"
  spec.version       = ADNCV::VERSION
  spec.authors       = ["Eric Dejonckheere"]
  spec.email         = ["eric@aya.io"]
  spec.summary       = %q{Statistics from your App.net data.}
  spec.description   = %q{Statistics from your downloaded App.net data.}
  spec.homepage      = "https://github.com/ericdke/ADNCV"
  spec.license       = "MIT"

  spec.bindir        = 'bin'
  spec.files         = `git ls-files`.split("\n")
  spec.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  spec.executables   = %w{adncv}
  spec.require_paths = ["lib"]

  spec.add_dependency "thor", "~> 0.19"
  spec.add_dependency "terminal-table", "~> 1.4"

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
