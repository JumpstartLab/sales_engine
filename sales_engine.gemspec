# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)
 
require 'bundler/version'
 
Gem::Specification.new do |s|
  s.name        = "sales_engine"
  s.version     = 1
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Chris Maddox", "Horace Williams"]
  s.email       = ["chris.maddox@livingsocial.com", "horace.williams@livingsocial.com"]
  s.homepage    = "http://github.com/tyre/sales_engine"
  s.summary     = "balls on mah face"
  s.description = "ENGINIZES UR SALES ALL DAY"
 
  s.required_rubygems_version = ">= 1.3.6"
 
  s.add_development_dependency ["rspec", "awesome_print"]

 
  s.files        = Dir.glob("{lib}/**/*")
  s.require_path = 'lib'
end