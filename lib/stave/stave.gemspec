require_relative "lib/stave/version"

Gem::Specification.new do |spec|
  spec.name        = "stave"
  spec.version     = Stave::VERSION
  spec.authors     = ["Hunt Redmine"]
  spec.email       = ["hunt@red-mine.com"]
  spec.homepage    = "https://red-mine.com/"
  spec.summary     = "Stave for Stock."
  spec.description = "Description of Stave."
  spec.license     = "MIT"
  
  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  spec.metadata["allowed_push_host"] = "https://red-mine.com/"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://red-mine.com/"
  spec.metadata["changelog_uri"] = "https://red-mine.com/"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", ">= 7.0.4.2"
end
