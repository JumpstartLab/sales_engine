$LOAD_PATH.unshift(File.dirname(__FILE__) + '/lib').uniq!
# $LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'lib')).uniq!

require 'sales_engine'

SalesEngine.startup

# add module SalesEngine wrapper to every class
# add SalesEngine:: to every class invocation
# add lib/sales_engine.rb with requires for every class