require_relative "lib/crm/version"

Gem::Specification.new do |spec|
  spec.name = "crm"
  spec.version = Crm::VERSION
  spec.authors = ["ledob44"]
  spec.email = ["olivier.imbert@unit.eu"]
  spec.homepage = "https://github.com/fondation-unit/rails-crm"
  spec.summary = "Rails CRM."
  spec.description = "Rails CRM."
  spec.license = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata[
    "source_code_uri"
  ] = "TODO: Put your gem's public repo URL here."
  spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  spec.files =
    Dir.chdir(File.expand_path(__dir__)) do
      Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
    end

  spec.add_dependency "csv"
  spec.add_dependency "pagy", ">= 43"
  spec.add_dependency "rails", ">= 8.1.3"
  spec.add_dependency "telephone_number"
  spec.add_dependency "zeitwerk"

  spec.add_development_dependency "rubocop"
  spec.add_development_dependency "rubocop-rails-omakase"
end
