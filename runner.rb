$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'lib')).uniq!

require 'sales_engine'
include SalesEngine

SalesEngine.startup
n = SalesEngine::Merchant.find_by_id(2).merch_revenue_by_date("2012-02-14")
puts n.inspect
