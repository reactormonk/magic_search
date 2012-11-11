Gem::Specification.new do |s|
  s.name        = "magic-cards"
  s.version     = "0.1.0"
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Simon Hafner"]
  s.email       = ["hafnersimon@gmail.com"]
  s.summary     = "Reads magic card info from http://dl.dropbox.com/u/2771470/index.html"
  s.description = "Nothing further"

  s.required_rubygems_version = ">= 1.3.6"

  # lol - required for validation
  s.rubyforge_project         = "magic-cards"

  # If you have other dependencies, add them here
  s.add_dependency "nokogiri"

  # If you need to check in files that aren't .rb files, add them here
  s.files        = Dir["{lib}/**/*.rb", "bin/*", "LICENSE", "*.md", "data/*"]
  s.require_path = 'lib'

  # If you need an executable, add it here
  # s.executables = ["newgem"]

  # If you have C extensions, uncomment this line
  # s.extensions = "ext/extconf.rb"
end
