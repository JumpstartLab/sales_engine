$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'lib')).uniq!

require 'sales_engine'

SalesEngine.startup
i = SalesEngine::Invoice.random
puts "#{i.inspect}"
puts ""
puts "#{i.invoice_items}"
puts ""
puts "#{i.items}"
# puts ""
# puts "#{i.items}"