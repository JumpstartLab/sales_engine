# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)
 
require 'bundler/version'
 
Gem::Specification.new do |s|
  s.name        = "sales_engine"
  s.version     = "1.0.0"
  s.authors     = ["Conan Rimmer", "Darrell Rivera"]
  s.email       = ["conan.rimmer@livingsocial.com", "darrell.rivera@livingsocial.com"]
  s.homepage    = "https://github.com/darrellrivera/sales_engine"
  s.summary     = "Data reporting tool that manipulates and reports on merchant transactional data"
  s.description = "Data reporting tool that manipulates and reports on merchant transactional data"
 
  s.required_rubygems_version = ">= 1.3.6"
 
  s.add_development_dependency "rspec"
 
  s.files        = Dir.glob("{bin,lib,data}/**/*")
  s.require_path = 'lib'
end