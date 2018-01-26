# coding: utf-8

lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "grape_on_rails/version"

Gem::Specification.new do |spec|
  spec.name          = "grape_on_rails"
  spec.version       = GrapeOnRails::VERSION
  spec.authors       = ["topcbl"]
  spec.email         = ["topcbl@gmail.com"]

  spec.summary       = %q(Bring Grape DSL to Rails-api. Make it easier for writing api.)
  spec.description   = %q(Bring Grape DSL to Rails-api. Make it easier for writing api.)
  spec.homepage      = "https://github.com/chau-bao-long/grape-on-rails"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "http://topcbl.online"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0")
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}){|f| File.basename(f)}
  spec.require_paths = ["lib"]

  rails_versions = [">= 4.1", "< 6"]

  spec.add_runtime_dependency "actionpack", rails_versions
  spec.add_runtime_dependency "activemodel", rails_versions
  spec.add_runtime_dependency "activerecord", rails_versions
  spec.add_runtime_dependency "activesupport", rails_versions
  spec.add_runtime_dependency "i18n", rails_versions
  spec.add_runtime_dependency "railties", rails_versions

  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
