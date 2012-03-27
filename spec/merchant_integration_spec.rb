 require 'spec_helper'

 describe "Merchant integration tests" do
   let(:sqlite_db) { SQLite3::Database.new('data/integration_test.sqlite')}

   before(:each) do
     SalesEngine::Database.instance.db = sqlite_db
   end
   describe "Merchant.most_revenue" do
     it "returns Merchants" do
     end

     it "returns Invoices" do
       #SalesEngine::Database.instance.invoices.each { |invoice| puts invoice.id }
     end

     it "returns Items" do
       #SalesEngine::Database.instance.items.each { |item| puts item.name}
     end

     it "returns Customers" do
       #SalesEngine::Database.instance.customers.each { |customer| puts customer.first_name}
     end

     it "returns Transactions" do
       #SalesEngine::Database.instance.transactions.each { |transaction| puts transaction.credit_card_number}
     end

     it "returns Invoice Items" do
       #SalesEngine::Database.instance.invoice_items.each { |invoice_item| puts invoice_item.unit_price }
     end
   end
 end
