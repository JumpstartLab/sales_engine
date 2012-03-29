require 'spec_helper'

describe SalesEngine::InvoiceItem do
  let(:se) { SalesEngine::Database.instance}
  let(:invoice_1) { Fabricate(:invoice) }
  let(:invoice_2) { Fabricate(:invoice) }
  let(:item_1) { Fabricate(:item) }
  let(:item_2) { Fabricate(:item) }
  let(:invoice_item_1) { Fabricate(:invoice_item, :invoice_id => invoice_2.id, :item_id => item_1.id) }
  let(:invoice_item_2) { Fabricate(:invoice_item, :invoice_id => invoice_1.id, :item_id => item_2.id) }
  let(:invoice_item_3) { Fabricate(:invoice_item) }


  before(:each) do
    se.clear_all_data
    se.add_to_list(invoice_item_1)
    se.add_to_list(invoice_item_2)
    se.add_to_list(invoice_item_3)
    se.add_to_list(item_1)
    se.add_to_list(item_2)
    se.add_to_list(invoice_1)
    se.add_to_list(invoice_2)
  end

  describe "#invoice" do
    context "where there are invoices in the database" do
      it "returns an instance of Invoice associated with this object" do
        invoice_item_1.invoice.should == invoice_2
      end
    end
  end

  describe "#item" do
    context "where there are items in the database" do
      let(:item_1) { Fabricate(:item) }
      let(:item_2) { Fabricate(:item) }

      before(:each) do
        se.add_to_list(item_1)
        se.add_to_list(item_2)
        invoice_item_1.item_id = item_2.id
        invoice_item_2.item_id = item_1.id
      end

      it "returns an instance of Item associated with this object" do
        invoice_item_1.item.should == item_2
      end
    end
  end

  describe ".random" do
    context "when invoice items exist in the datastore" do
      it "returns a random invoice item record" do
        se.invoiceitems.include?(SalesEngine::InvoiceItem.random).should be_true
      end
    end

    context "when there are no invoice items in the datastore" do
      it "returns nil" do
        se.clear_all_data
        SalesEngine::InvoiceItem.random.should be_nil
      end
    end
  end

  describe ".find_by_id" do
    context "when invoice items exist in the datastore" do
      it "returns the invoice items associated with the id" do
        SalesEngine::InvoiceItem.find_by_id(invoice_item_2.id).should == invoice_item_2
      end
    end

      it "returns nothing if no invoice items records match the id" do
        SalesEngine::InvoiceItem.find_by_id(100).should be_nil
      end

    context "when there are no invoice items in the datastore" do
      it "returns nothing" do
        se.clear_all_data
        SalesEngine::InvoiceItem.find_by_id(invoice_item_2.id).should be_nil
      end
    end
  end

  describe ".find_by_item_id" do
    context "when there are invoice items in the datastore" do
      it "returns the invoice items associted with the item id" do
        SalesEngine::InvoiceItem.find_by_item_id(item_1.id).should == invoice_item_1
      end

      it "returns nothing if no invoice items match the item id" do
        SalesEngine::InvoiceItem.find_by_item_id(100023243).should be_nil
      end
    end
  end

  describe ".find_by_invoice_id" do
    context "when there are invoice items in the datastore" do
      it "returns the invoice items associated with the invoice id" do
        SalesEngine::InvoiceItem.find_by_invoice_id(invoice_2.id).should == invoice_item_1
      end

      it "returns nothing if no invoice items match the invoice id" do
        SalesEngine::InvoiceItem.find_by_invoice_id(100).should be_nil
      end
    end

    context "when there are no invoice items in the datastore" do
      it "returns nothing" do
        se.clear_all_data
        SalesEngine::InvoiceItem.find_by_invoice_id(invoice_2.id).should be_nil
      end
    end
  end

  describe "#total" do
    it "returns the total revenue for the invoice item" do
      invoice_item_1.quantity = 3
      invoice_item_1.unit_price = 4
      invoice_item_1.total.should == 12
    end
  end
end