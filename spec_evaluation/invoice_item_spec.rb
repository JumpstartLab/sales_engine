require 'spec_helper'

describe InvoiceItem do
  context "Searching" do
    describe ".random" do
      it "usually returns different things on subsequent calls" do
        invoice_item_one = InvoiceItem.random
        10.times do
          invoice_item_two = InvoiceItem.random
          break if invoice_item_one != invoice_item_two
        end

        invoice_item_one.should_not == invoice_item_two
      end
    end

    describe ".find_by_item_id" do
      invoice_item = InvoiceItem.find_by_item_id 123
      invoice_item.invoice_id.should == 970
    end

    describe ".find_all_by_quantity" do
      invoice_items = InvoiceItem.find_all_by_quantity 10
      invoice_items.should have(2222).invoice_items
    end
  end

  context "Relationships" do
    let(:invoice_item) { InvoiceItem.find_by_id 16934 }

    describe "#item" do
      it "exists" do
        invoice_item.item.name.should == "Item Dolorem Illum"
      end
    end

    describe "#invoice" do
      it "exists" do
        invoice_customer = Customer.find_by_id 776
        invoice_item.customer.name.should == invoice.customer.name
      end
    end

  end

  context "Business Intelligence" do

  end
end

