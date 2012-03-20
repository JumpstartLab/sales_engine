require "./merchant"
require "./customer"
require "./transaction"
require "./invoice"
require "./item"
require "./invoice_item"
require "rspec"
require "date"

describe Merchant do

  let(:test_merchant) do 
    attr_hash = {id: 1,name: "Joe's Crab Shack", created_at:Date.today, updated_at: Date.today}
    Merchant.new(attr_hash)
  end

  context "#items" do
    it "returns an array of items" do
      items = test_merchant.items
      items.should be_is_a(Array)
    end

    it "should return and array of Items" do
      items = test_merchant.items
      items.each do |item|
        item.should be_is_a(Item)
      end
    end
  end

  context "#invoices" do
    it "returns an array" do
      invoices = test_merchant.invoices
      invoices.should be_is_a(Array)
    end

    it "returns an array of Invoices" do
      invoices = test_merchant.invoices
      invoices.each do |invoice|
        invoice.should be_is_a(Invoice)
      end
    end
  end

  context "#revenue" do
    it "returns a valid total revenue without argument" do
      revenue = test_merchant.revenue
      revenue.should be_is_a(BigDecimal)
    end

    it "returns a valid number for a given date" do
      revenue = test_merchant.revenue(Date.today)
      revenue.should be_is_a(BigDecimal)
    end
  end

  # context "#favorite_customer" do
  #   it "returns a customer object" do
  #     test_merchant.favorite_customer.should be_is_a(Customer)
  #   end
    
  #   it "returns the customer with highest number of transactions" do
  #     c1 = Customer.new(:transactions => [Transaction.new, Transaction.new])
  #     c2 = Customer.new(:transactions => [Transaction.new])
  #     t1 = 
  #     test_merchant
  #   end
  # end
end



























