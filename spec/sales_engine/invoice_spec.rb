require 'spec_helper'

describe SalesEngine::Invoice do

  let(:invoice) do
    i = Fabricate(:invoice)
    #puts i.inspect
    i
  end

  describe ".random" do
    it "returns an invoice" do
      SalesEngine::Invoice.random.class.should == SalesEngine::Invoice
    end

    it "returns different invoices on two calls" do
      y = SalesEngine::Invoice.random
      z = SalesEngine::Invoice.random

      while y == z
        y = SalesEngine::Invoice.random
        z = SalesEngine::Invoice.random
      end

      y should_not = z

    end
  end

  describe ".find_by_id" do

    it "returns an invoice" do
      SalesEngine::Invoice.find_by_id(3).class.should == SalesEngine::Invoice
    end

    it "returns the correct invoice id" do
      random_id = rand(100)
      SalesEngine::Invoice.find_by_id(random_id).id.should == random_id
    end
  end

  describe ".find_all_by_id" do

    it "returns an array" do
      SalesEngine::Invoice.find_all_by_id(3).class.should == Array
    end
  end

  describe "#transactions" do
    it "returns an array" do
      SalesEngine::Invoice.random.transactions.class.should == Array
    end

    it "returns an array of transaction objects" do
      SalesEngine::Invoice.random.transactions.each do |trans|
        trans.class == SalesEngine::Transaction
      end
    end
  end

  describe "#invoice_items" do
    it "returns an array" do
      SalesEngine::Invoice.random.invoice_items.class.should == Array
    end

   it "returns an array of invoice item objects" do
      SalesEngine::Invoice.random.invoice_items.each do |inv_item|
        inv_item.class == SalesEngine::InvoiceItem
      end
    end 
  end

  describe "#items" do
    it "returns an array" do
      SalesEngine::Invoice.random.items.class.should == Array
    end

   it "returns an array of item objects" do
      SalesEngine::Invoice.random.items.each do |item|
        item.class == SalesEngine::Item
      end
    end 
  end

  describe "#customer" do
    it "returns a customer object" do
      SalesEngine::Invoice.random.customer.class.should == SalesEngine::Customer
    end
  end

  describe "#revenue" do
    it "returns an integer" do
      SalesEngine::Invoice.random.revenue.class.should == Fixnum
    end
  end

  describe ".create" do
    customer1 = SalesEngine::Customer.random
    merchant1 = SalesEngine::Merchant.random
    item1 = SalesEngine::Item.random
    item2 = SalesEngine::Item.random
    it "creates a new invoice" do
      invoice = SalesEngine::Invoice.create(customer: customer1,
                                            merchant: merchant1,
                                            items: [item1, item2])
      invoice.class.should == SalesEngine::Invoice
      invoice.merchant_id.should == merchant1.id
    end
  end

  describe "#charge" do
    it "creates a transaction" do
      invoice1 = SalesEngine::Invoice.random
      transaction1 = invoice1.charge(credit_card_number: '122345678923456',  credit_card_expiration_date: "12/19", result: "success")
      transaction1.class.should ==SalesEngine::Transaction
      transaction1.invoice.id.should == invoice1.id
    end
  end
  
end
