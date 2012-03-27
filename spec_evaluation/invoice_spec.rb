require 'spec_helper'

describe Invoice do
  context "Searching" do
    describe ".random" do
      it "usually returns different things on subsequent calls" do
        invoice_one = Invoice.random
        10.times do
          invoice_two = Invoice.random
          break if invoice_one != invoice_two
        end

        invoice_one.should_not == invoice_two
      end
    end

    describe ".find_by_name" do
      invoices = Invoice.find_by_status "cool"
      invoices.should be_nil
    end

    describe ".find_by_all_status" do
      invoices = Invoice.find_all_by_status "shipped"
      invoices.should have(4873).invoices
    end
  end

  context "Relationships" do
    let(:invoice) { Invoice.find_by_id 1002 }

    describe "#transactions" do
      it "has 1 of them" do
        invoice.transactions.should have(1).transaction
      end
    end

    describe "#items" do
      it "has 5 of them" do
        invoice.items.should have(5).items
      end

      it "has one for 'Item Id Rerum'" do
        item = invoice.items.find {|i| i.name == 'Item Id Rerum' }
        item.should_not be_nil
      end
    end

    describe "#customer" do
      it "exists" do
        invoice.customer.first_name.should == "Gleichner"
        invoice.customer.last_name.should  == "Carleton"
      end
    end

    describe "#items" do
      it "has 5 of them" do
        invoice.invoice_items.should have(5).items
      end

      it "has one for an item 'Item Id Rerum'" do
        item = invoice.invoice_items.find {|ii| ii.item.name == 'Item Id Rerum' }
        item.should_not be_nil
      end
    end
  end

  context "Business Intelligence" do

    describe ".create" do
      let(:customer) { Customer.random }
      let(:merchant) { Merchant.random }
      let(:items) do
        (1..3).map { Item.random }
      end
      it "creates a new invoice" do

        invoice = Invoice.create(customer: customer, merchant: merchant, items: items)
        pending "Verify relationships"

      end
    end

  end
end
