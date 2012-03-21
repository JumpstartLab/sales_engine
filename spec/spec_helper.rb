require 'simplecov'
SimpleCov.start do
  add_filter "/spec/"
end

require './customer'
require './item'
require './invoice'
require './transaction'
require './invoiceitem'
require './merchant'