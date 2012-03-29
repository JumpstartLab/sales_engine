require 'spec_helper'

describe SalesEngine::InvoiceItem do
  context "Searching" do
    describe ".random" do
      it "usually returns different things on subsequent calls" do
        invoice_item_one = SalesEngine::InvoiceItem.random
        invoice_item_two = SalesEngine::InvoiceItem.random

        10.times do
          break if invoice_item_one.id != invoice_item_two.id
          invoice_item_two = SalesEngine::InvoiceItem.random
        end

        invoice_item_one.id.should_not == invoice_item_two.id
      end
    end

    describe ".find_by_item_id" do
      it "can find a record" do
        invoice_item = SalesEngine::InvoiceItem.find_by_item_id 123
        invoice_item.item.name.should == "Item Doloribus Ducimus"
      end
    end

    describe ".find_all_by_quantity" do
      it "can find multiple records" do
        invoice_items = SalesEngine::InvoiceItem.find_all_by_quantity 10
        invoice_items.should have(2140).invoice_items
      end
    end
  end

  context "Relationships" do
    let(:invoice_item) { SalesEngine::InvoiceItem.find_by_id 16934 }

    describe "#item" do
      it "exists" do
        invoice_item.item.name.should == "Item Cupiditate Magni"
      end
    end

    describe "#invoice" do
      it "exists" do
        invoice_item.invoice.should be
      end
    end

  end

  context "Business Intelligence" do

  end
end

