$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'lib')).uniq!

require 'sales_engine'
include SalesEngine

SalesEngine.startup
n= SalesEngine::Merchant.find_by_name("Parisian Group").customers_with_pending_invoices
puts n.inspect
puts n.length