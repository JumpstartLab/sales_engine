$LOAD_PATH << './'
$LOAD_PATH << './lib/sales_engine'
$LOAD_PATH << './data'
require 'simplecov'
SimpleCov.start do
  add_filter "/spec/"
end
require 'sales_engine'
include SalesEngine