require 'spec_helper'

describe SalesEngine::Merchant do
  describe "#invoices" do
    let(:invoice1) { mock(SalesEngine::Invoice) }
    let(:invoice2) { mock(SalesEngine::Invoice) }
    let(:invoice3) { mock(SalesEngine::Invoice) }

    before(:each) do
      invoice1.stub(:merchant_id).and_return(1)
      invoice2.stub(:merchant_id).and_return(2)
      invoice3.stub(:merchant_id).and_return(1)

      invoices = [invoice1, invoice2, invoice3]
      SalesEngine::Database.stub(:invoices).and_return(invoices)
    end


    context "when merchant has one invoice" do
      it "returns an array containing the single invoice" do
        merchant = SalesEngine::Merchant.new(2, "", "", "")
        merchant.invoices.should == [invoice2]
      end
    end

    context "when merchant has multiple invoices" do
      it "returns all invoices" do
        merchant = SalesEngine::Merchant.new(1, "", "", "")
        merchant.invoices.should == [invoice1, invoice3]
      end
    end

    context "when merchant has no invoices" do
      it "returns an empty array" do
        merchant = SalesEngine::Merchant.new(3, "", "", "")
        merchant.invoices.should == []
      end
    end
  end

  describe "#items" do
    let(:item1) { mock(SalesEngine::Item) }
    let(:item2) { mock(SalesEngine::Item) }
    let(:item3) { mock(SalesEngine::Item) }

    before(:each) do
      item1.stub(:merchant_id).and_return(1)
      item2.stub(:merchant_id).and_return(2)
      item3.stub(:merchant_id).and_return(1)

      items = [item1, item2, item3]
      SalesEngine::Database.stub(:items).and_return(items)
    end


    context "when merchant has one item" do
      it "returns an array containing the single item" do
        merchant = SalesEngine::Merchant.new(2, "", "", "")
        merchant.items.should == [item2]
      end
    end

    context "when merchant has multiple items" do
      it "returns all items" do
        merchant = SalesEngine::Merchant.new(1, "", "", "")
        merchant.items.should == [item1, item3]
      end
    end

    context "when merchant has no items" do
      it "returns an empty array" do
        merchant = SalesEngine::Merchant.new(3, "", "", "")
        merchant.items.should == []
      end
    end
  end
end