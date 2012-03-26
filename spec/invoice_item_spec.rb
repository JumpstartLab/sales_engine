require './spec/spec_helper'

describe SalesEngine::InvoiceItem do
  describe ".get_invoice_items" do
    before(:all) { SalesEngine::InvoiceItem.get_invoice_items }
    it "stores records from invoice_item.csv in @@records" do
      SalesEngine::InvoiceItem.records.map(&:class).uniq.should == [SalesEngine::InvoiceItem]
    end
    {id: 1, item_id: 2138, invoice_id: 1, quantity: 1,
      unit_price: BigDecimal("485.45")}.each do |attribute, value|
      it "records #{attribute}" do
        SalesEngine::InvoiceItem.records.first.send(attribute).should == value
      end
    end
  end

  context "instance methods" do
    let(:invoice_item) { SalesEngine::InvoiceItem.find_by_id(1) }
    describe "#invoice" do
      it "returns an invoice" do
        invoice_item.invoice.should be_a(SalesEngine::Invoice)
      end
      it "returns the invoice associated with this invoice_item" do
        invoice_item.invoice.should == SalesEngine::Invoice.find_by_id(1)
      end
    end
    describe "#item" do
      it "returns an item" do
        invoice_item.item.should be_a(SalesEngine::Item)
      end
      it "returns the item associated with this invoice_item" do
        invoice_item.item.should == SalesEngine::Item.find_by_id(2138)
      end
    end
  end
end

# id,item_id,invoice_id,quantity,unit_price,created_at,updated_at
# 1,2138,1,1,48545,2012-02-26 20:56:56 UTC,2012-02-26 20:56:56 UTC