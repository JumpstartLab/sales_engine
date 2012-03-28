require 'spec_helper'

module SalesEngine
  describe InvoiceItem do
    describe "#item" do
      let(:invoice_item) { Fabricate(:invoice_item, :id => 1) }
      let(:item) { mock(Item) }
      let(:other_item) { mock(Item) }

      before(:each) do
        item.stub(:id).and_return(1)
        other_item.stub(:id).and_return(2)
        Database.instance.stub(:items).and_return([item, other_item])
      end

      it "returns the item with matching item_id" do
        invoice_item.item.should == item
      end
    end

    describe "#invoice" do
      let(:invoice_item) { Fabricate(:invoice_item, :id => 1) }
      let(:invoice) { mock(Invoice) }
      let(:other_invoice) { mock(Invoice) }

      before(:each) do
        invoice.stub(:id).and_return(1)
        other_invoice.stub(:id).and_return(2)
        Database.instance.stub(:invoices).and_return([invoice, other_invoice])
      end

      it "returns the invoice with matching invoice_id" do
        invoice_item.invoice.should == invoice
      end
    end
  end
end