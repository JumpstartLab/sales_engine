$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'lib')).uniq!

require 'sales_engine'

SalesEngine.startup
m = SalesEngine::Merchant.random
puts "#{m.inspect}"
puts ""
puts "#{m.invoices}"
puts ""
puts "#{m.charged_invoices}"
puts ""
puts "#{m.revenue}"
puts ""
puts "#{m.favorite_customer}"
# puts ""
# puts "#{i.items}"
# puts ""
# puts "#{i.items}"