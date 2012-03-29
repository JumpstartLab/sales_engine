require 'bundler'

Bundler.require(:default, :test)

require 'sales_engine'
require 'date'

RSpec.configure do |config|
  config.before(:suite) do
    SalesEngine.startup
  end
end