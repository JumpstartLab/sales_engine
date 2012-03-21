require 'simplecov'
SimpleCov.start do
  add_filter "/spec/"
end

require './sales_engine'
require './merchant'
require './item'
require './invoice'