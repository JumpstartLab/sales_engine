require 'simplecov'
SimpleCov.start do
  add_filter "/spec/"
end

require 'bundler'
Bundler.require

require './merchant'
require './item'
require './invoice_item'
require './invoice'
require './customer'
require './transaction'