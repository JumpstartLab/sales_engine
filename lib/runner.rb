
require 'awesome_print'
require './lib/sales_engine'

SalesEngine.startup

SalesEngine::Merchant.dates_by_revenue.each do |date|
  ap date
end

