require 'spec_helper'

describe SalesEngine::Item do
  describe ".merchant" do
    let(:merchant) { mock(SalesEngine::Merchant) }
    let(:merchant2) { mock(SalesEngine::Merchant)}
    let(:item) { SalesEngine::Item.new(1, "", "", 0, 1, Date.today, Date.today)}
    it "returns the merchant with the correct id" do
      merchant.stub(:id).and_return(1)
      merchant2.stub(:id).and_return(2)
      SalesEngine::Database.stub(:merchants).and_return([merchant, merchant2])
      item.merchant.should == merchant
    end
  end

  describe ".invoice_items" do
    let(:item) { SalesEngine::Item.new(1, "", "", 0, 1, Date.today, Date.today)}
    let(:invoice_item) { mock(SalesEngine::InvoiceItem) }
    let(:invoice_item2) { mock(SalesEngine::InvoiceItem) }
    let(:invoice_item3) { mock(SalesEngine::InvoiceItem) }

    before(:each) do
      invoice_item.stub(:item_id).and_return(1)
      invoice_item2.stub(:item_id).and_return(2)
      invoice_item3.stub(:item_id).and_return(1)
      invoice_items = [invoice_item, invoice_item2, invoice_item3]
      SalesEngine::Database.stub(:invoice_items).and_return(invoice_items)
    end

    context "when one invoice item matches item id" do
      it "returns an array containing that one invoice_item object" do
        item.id = 2
        item.invoice_items.should == [invoice_item2]
      end
    end
    context "when multiple invoice items match item id" do
      it "returns an array of all matching invoice_item objects" do
        item.invoice_items.should == [invoice_item, invoice_item3]
      end
    end
    context "when no invoice items match item id" do
      it "returns an empty array" do
        item.id = 3
        item.invoice_items.should == []
      end
    end
  end
end