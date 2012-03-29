$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'lib')).uniq!

require 'sales_engine'
include SalesEngine

SalesEngine.startup
n= SalesEngine::Item.find_by_name("Item Alias Nihil").unit_price
puts n.inspect