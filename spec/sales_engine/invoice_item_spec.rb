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