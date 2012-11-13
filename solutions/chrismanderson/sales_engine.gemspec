lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'bundler/version'

Gem::Specification.new do |s|
  s.name        = "sales_engine"
  s.version     = 1.0
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Chris Anderson", "Jacqueline Chenault"]
  s.email       = ["chris.anderson+jacqueline.chenault@hungrymachine.com"]
  s.homepage    = "https://github.com/chrismanderson/sales_engine"
  s.summary     = "Sales Engine!"
  s.description = "Sales Engine project for Hungry Academy"
 
  s.required_rubygems_version = ">= 1.3.6"
  s.add_development_dependency "rspec"
 
  s.files        = Dir.glob("{data,lib}/**/*")
  s.executables  = []
  s.require_path = 'lib'
end