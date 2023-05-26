# frozen_string_literal: true

require_relative "lib/instant18n/version"

Gem::Specification.new do |spec|
  spec.name = "instant18n"
  spec.version = Instant18n::VERSION
  spec.authors = ["Obie Fernandez"]
  spec.email = ["obiefernandez@gmail.com"]

  spec.summary = "Instant18n is a gem that makes it drop-dead simple to internationalize your application."
  spec.description = "Uses the power of OpenAI's GPT large language AI models to generate translations for your application."
  spec.homepage = "https://github.com/obie/instant18n"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/obie/instant18n"
  spec.metadata["changelog_uri"] = "https://github.com/obie/instant18n/changelog.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) || f.start_with?(*%w[bin/ test/ spec/ features/ .git .circleci appveyor])
    end
  end

  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  spec.add_dependency "actionview"
  spec.add_dependency "activesupport"
  spec.add_dependency "railties"
  spec.add_dependency "ruby-openai", ">= 4.0.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
