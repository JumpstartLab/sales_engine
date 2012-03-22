$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'lib')).uniq!

require 'sales_engine'

SalesEngine.startup
#puts "#{SalesEngine::Item.find_by_id("1").inspect}"