require 'spec_helper'

describe SalesEngine::InvoiceItem do

  describe ".random" do
    it "returns a an Invoice Item" do
      SalesEngine::InvoiceItem.random.class.should == SalesEngine::InvoiceItem
    end

    it "returns different invoice items on two calls" do
      y = SalesEngine::InvoiceItem.random
      z = SalesEngine::InvoiceItem.random

      while y == z
        y = SalesEngine::InvoiceItem.random
        z = SalesEngine::InvoiceItem.random
      end

      y should_not = z

    end
  end

  describe ".find_by_id" do
    id = rand(2000) + 1
    it "returns an item" do
      SalesEngine::InvoiceItem.find_by_id(id).class.should == SalesEngine::InvoiceItem
    end
  end

  describe ".find_all_by_id" do
    id = rand(2000) + 1
    it "returns an array" do
      SalesEngine::InvoiceItem.find_all_by_id(id).class.should == Array
    end

    it" returns an array with items" do
      SalesEngine::InvoiceItem.find_all_by_id(id).each do |item|
        item.class.should == SalesEngine::InvoiceItem
      end
    end
  end

  describe "#item" do
    invoice_item1 = SalesEngine::InvoiceItem.random
    it "returns an item" do
      invoice_item1.item.class.should == SalesEngine::Item
    end
  end

  describe "#invoice" do
    invoice_item1 = SalesEngine::InvoiceItem.random
    it "returns an invoice" do
      invoice_item1.invoice.class.should == SalesEngine::Invoice
    end
  end
end