require 'bundler'
Bundler.require(:test)

SimpleCov.start
require 'sales_engine'

SalesEngine.startup('data/evaluation')
