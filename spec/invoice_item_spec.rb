require './spec/spec_helper'

describe SalesEngine::InvoiceItem do
  let(:se) { SalesEngine::Database.instance}
  let(:invoice_item_1) { SalesEngine::InvoiceItem.new({:id => 1}) }
  let(:invoice_item_2) { SalesEngine::InvoiceItem.new({:id => 2}) }

  before(:each) do
    se.clear_all_data
    se.add_to_list(invoice_item_1)
    se.add_to_list(invoice_item_2)
  end

  describe "#invoice" do
    context "where there are invoices in the database" do
      let(:invoice_1) { SalesEngine::Invoice.new({ :id => 1 }) }
      let(:invoice_2) { SalesEngine::Invoice.new({ :id => 2 }) }

      before(:each) do
        se.add_to_list(invoice_1)
        se.add_to_list(invoice_2)
        invoice_item_1.invoice_id = invoice_2.id
        invoice_item_2.invoice_id = invoice_1.id
      end

      it "returns an instance of Invoice associated with this object" do
        invoice_item_1.invoice.should == invoice_2
      end
    end
  end

  describe "#item" do
    context "where there are items in the database" do
      let(:item_1) { SalesEngine::Item.new({ :id => 1 }) }
      let(:item_2) { SalesEngine::Item.new({ :id => 2 }) }
      
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
end