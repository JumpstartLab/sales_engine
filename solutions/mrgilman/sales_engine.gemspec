lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)
 
require 'bundler/version'
 
Gem::Specification.new do |s|
  s.name        = "sales_engine"
  s.version     = 1
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Andy Glass", "Melanie Gilman"]
  s.email       = ["melanie.gilman@livingsocial.com"]
  s.homepage    = "https://github.com/mrgilman/sales_engine"
  s.summary     = "The best Sales Engine there is"
  s.description = "This really is the best Sales Engine there is"
 
  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project         = "bundler"
 
  s.add_development_dependency "rspec"
 
  s.files        = Dir.glob("{bin,lib}/**/*")
  s.require_path = 'lib'
end