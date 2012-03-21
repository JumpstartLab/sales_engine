$LOAD_PATH << './lib'

require 'bundler'
Bundler.require(:test)
SimpleCov.start 

require './lib/merchant'
require './lib/invoice'
require './lib/item'
require './lib/sales_engine'
require './lib/invoice_item'
require './lib/transaction'
require './lib/customer'


