require 'spec_helper'

describe SalesEngine::InvoiceItem do
  context "Searching" do
    describe ".random" do
      it "usually returns different things on subsequent calls" do
        invoice_item_one = SalesEngine::InvoiceItem.random
        10.times do
          invoice_item_two = SalesEngine::InvoiceItem.random
          break if invoice_item_one.id != invoice_item_two.id
        end

        invoice_item_one.id.should_not == invoice_item_two.id
      end
    end

    describe ".find_by_item_id" do
      invoice_item = SalesEngine::InvoiceItem.find_by_item_id 123
      invoice_item.invoice_id.should == 26
    end

    describe ".find_all_by_quantity" do
      invoice_items = SalesEngine::InvoiceItem.find_all_by_quantity 10
      invoice_items.should have(2140).invoice_items
    end
  end

  context "Relationships" do
    let(:invoice_item) { SalesEngine::InvoiceItem.find_by_id 16934 }

    describe "#item" do
      it "exists" do
        invoice_item.item.name.should == "Item Qui Esse"
      end
    end

    describe "#invoice" do
      it "exists" do
        invoice_customer = SalesEngine::Customer.find_by_id invoice_item.customer_id
        invoice_item.customer.last_name.should == invoice.customer.last_name
      end
    end

  end

  context "Business Intelligence" do

  end
end

