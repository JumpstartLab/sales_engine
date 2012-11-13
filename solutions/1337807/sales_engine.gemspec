# -*- encoding: utf-8 -*-

lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'bundler/version'

Gem::Specification.new do |s|
  s.name        = "sales_engine"
  s.version     = 1
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Jonan Scheffler", "Nisarg Shah"]
  s.email       = ["jonanscheffler+nisargshah100@gmail.com"]
  s.homepage    = "https://1337807@github.com/1337807/sales_engine.git"
  s.summary     = "Infernal hellspawn of a project devised by evil pirate Yoho and deathlord Casimir"
  s.description = "This calculates revenue of useless pretend merchants and makes programmers want to die."

  s.required_rubygems_version = ">= 1.3.6"

  s.add_development_dependency "rspec"

  s.files        = Dir.glob("lib/**/*")
  s.require_path = 'lib'
end
