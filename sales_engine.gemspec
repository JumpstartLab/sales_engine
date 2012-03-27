# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)
 
require 'bundler/version'
 
Gem::Specification.new do |s|
  s.name        = "sales_engine"
  s.version     = 1.0
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Dan Kaufman", "Austen Ito"]
  s.email       = ["dankaufman+austen.ito@hungrymachine.com"]
  s.homepage    = "https://github.com/dkaufman/sales_engine"
  s.summary     = "Sales Engine!"
  s.description = "Sales Engine Description"
 
  s.required_rubygems_version = ">= 1.3.6"
  s.add_development_dependency "rspec"
 
  s.files        = Dir.glob("{data,lib}/**/*")
  s.executables  = []
  s.require_path = 'lib'
  s.add_runtime_dependency "sqlite3"
  s.add_runtime_dependency "faker"
  s.add_runtime_dependency "fabrication"
end
