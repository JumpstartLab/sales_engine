$LOAD_PATH.unshift(File.join(File.expand_path(File.dirname(__FILE__), 'lib/'))).uniq!
puts File.expand_path(File.dirname(__FILE__))
puts $LOAD_PATH
require 'sales_engine/load'

SalesEngine.startup