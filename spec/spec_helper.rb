$LOAD_PATH << './'
$LOAD_PATH << './lib/sales_engine'
$LOAD_PATH << './data'
require 'bundler'
Bundler.require(:default,:test)
require 'simplecov'
SimpleCov.start do
  add_filter "/spec/"
end
require 'sales_engine'
extend SalesEngine

SalesEngine.startup