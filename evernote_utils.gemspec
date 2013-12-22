# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'evernote_utils/version'

Gem::Specification.new do |spec|
  spec.name          = "evernote_utils"
  spec.version       = ENUtils::VERSION
  spec.authors       = ["memerelics"]
  spec.email         = ["takuya21hashimoto@gmail.com"]
  spec.description   = %q{A thin OOP-friendly wrapper of Evernote Ruby SDK.}
  spec.summary       = %q{A thin OOP-friendly wrapper of Evernote Ruby SDK.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'evernote-thrift', '~>1.25.1'
  spec.add_dependency 'activesupport', '~>3.2.13'

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "mocha"
end
