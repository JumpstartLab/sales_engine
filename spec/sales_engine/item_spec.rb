require 'spec_helper'

describe SalesEngine::Item do

  let (:test_item){ Fabricate(:item) }

  describe "#invoice_items" do
    context "returns a collection of invoice items" do

      it "contains things which are only invoice items" do
        test_item.invoice_items.all?{|i| i.is_a? SalesEngine::InvoiceItem}.should == true
      end

      it "contains invoice items associated with only this item" do
        test_item.invoice_items.all? {|i|
          i.item_id == test_item.id}.should == true
      end
    end
  end

  describe "#merchant" do
    context "returns a merchant" do
      it "is a merchant" do
        test_item.merchant.should be_a SalesEngine::Merchant
      end

      it "is associated with this item" do
        test_item.merchant.id.should == test_item.merchant_id
      end
    end
  end

  describe ".random" do
    it "is an item" do
      SalesEngine::Item.random.should be_an SalesEngine::Item
    end
  end

  describe "#best_day" do
    it "returns a string of a date" do
      test_item.best_day.should =~ /[0-9][0-9][0-9][0-9][-][0-1][0-9]-[0-3][0-9]/
    end

    it "the date has the most sales for this item" do
      pending
    end
  end
end
