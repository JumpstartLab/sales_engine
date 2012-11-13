# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

Gem::Specification.new do |s|
  s.name        = "sales_engine"
  s.version     = "1.0.0"
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Mark Tabler", "Andrew Thal"]
  s.email       = ["andrew.thal+athal7+marktabler@livingsocial.com"]
  s.homepage    = "http://github.com/athal7/sales_engine"
  s.summary     = "Sales Engine project for Hungry Academy"
  s.description = "The best implementation of the Sales Engine project for Hungry Academy"

  s.required_rubygems_version = ">= 1.3.6"

  s.add_development_dependency "rspec"

  s.files        = Dir.glob("{lib}/**/*")
  s.require_path = 'lib'
end
