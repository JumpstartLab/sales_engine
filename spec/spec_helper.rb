require 'simplecov'
SimpleCov.start do
  add_filter "/spec/"
end

require './lib/database'
require './lib/customer'
require './lib/item'
require './lib/invoice'
require './lib/transaction'
require './lib/invoiceitem'
require './lib/merchant'