$LOAD_PATH.unshift(File.join(File.expand_path(File.dirname(__FILE__), 'lib/'))).uniq!

require 'sales_engine/load'

SalesEngine.startup