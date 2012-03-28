$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'lib')).uniq!

require 'sales_engine'
include SalesEngine

SalesEngine.startup
invoice = SalesEngine::Invoice.create(customer: SalesEngine::Customer.random,
  merchant: SalesEngine::Merchant.random,
  items: [SalesEngine::Item.find_by_id(3),SalesEngine::Item.find_by_id(3),SalesEngine::Item.find_by_id(4)])
n = invoice.charge(:credit_card_number => "4444333322221111", :credit_card_expiration_date => "10/13", :result => "success")
puts n.inspect
DataStore.instance.transactions.each do |t|
  puts t.inspect
end