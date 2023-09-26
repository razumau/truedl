# frozen_string_literal: true

require_relative "lib/truedl/version"

Gem::Specification.new do |spec|
  spec.name = "truedl"
  spec.version = TrueDL::VERSION
  spec.authors = ["Jury Razumau"]
  spec.email = ["mail@razumau.net"]

  spec.summary = "Ruby implementation of TrueDL."
  spec.homepage = "https://github.com/razumau/truedl"
  spec.license = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 3.0")

  spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "https://github.com/razumau/truedl/blob/main/CHANGELOG.md"

  spec.files = Dir.glob("lib/**/*") + %w[README.md]
  spec.require_paths = ["lib"]
end
