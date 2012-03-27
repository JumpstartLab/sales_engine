
require 'awesome_print'
require './lib/sales_engine'

SalesEngine.startup

SalesEngine::Merchant.dates_by_revenue.each do |date|
  ap date
end


test = SalesEngine::Merchant.find_by_id("25")

ap test

all_customers = SalesEngine::Database.instance.customer.collect do |i, hash|
    Database.instance.customer[i][:self]
  end

ap all_customers