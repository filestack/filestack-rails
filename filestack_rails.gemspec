$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "filestack_rails/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "filestack_rails"
  s.version     = FilestackRails::VERSION
  s.authors     = ["Richard"]
  s.email       = ["richard.alan.herbert@gmail.com"]
  s.homepage    = ""
  s.summary     = "Summary of FilestackRails."
  s.description = "Description of FilestackRails."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.1.2"

  s.add_development_dependency "sqlite3"
end
