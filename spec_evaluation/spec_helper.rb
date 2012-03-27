require 'bundler'

Bundler.require

require 'sales_engine'
require 'date'

# require './sales_engine'
# include SalesEngine

RSpec.configure do |config|
  config.before(:suite) do
    SalesEngine.startup
  end
end
