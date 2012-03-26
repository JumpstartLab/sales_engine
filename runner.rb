$LOAD_PATH.unshift(File.join(File.dirname(__FILE__),'lib')).uniq!

require './lib/sales_engine'

SalesEngine.startup
