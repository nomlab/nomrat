# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'nomrat/version'

Gem::Specification.new do |spec|
  spec.name          = "nomrat"
  spec.version       = Nomrat::VERSION
  spec.authors       = ["nomlab"]
  spec.email         = ["https://github.com/nomlab/nomrat"]
  spec.summary       = %q{Nomura Laboratory's Slack/Twitter bot.}
  spec.description   = %q{Nomura Laboratory's Slack/Twitter bot.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
