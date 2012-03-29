require 'spec_helper'

module SalesEngine
  describe Item do
    describe ".merchant" do
      let(:merchant) { mock(SalesEngine::Merchant) }
      let(:merchant2) { mock(SalesEngine::Merchant)}
      let(:item) { Fabricate(:item, :merchant_id => 1) }
      it "returns the merchant with the correct id" do
        merchant.stub(:id).and_return(1)
        merchant2.stub(:id).and_return(2)
        Merchant.stub(:merchants).and_return([merchant, merchant2])
        item.merchant.should == merchant
      end
    end

    describe ".invoice_items" do
      let(:item) { Fabricate(:item, :id => 1) }
      let(:invoice_item) { mock(SalesEngine::InvoiceItem) }
      let(:invoice_item2) { mock(SalesEngine::InvoiceItem) }
      let(:invoice_item3) { mock(SalesEngine::InvoiceItem) }

      before(:each) do
        invoice_item.stub(:item_id).and_return(1)
        invoice_item2.stub(:item_id).and_return(2)
        invoice_item3.stub(:item_id).and_return(1)
      end

      context "when one invoice item matches item id" do
        it "returns an array containing that one invoice_item object" do
          InvoiceItem.stub(:for_item).and_return([invoice_item2])
          item.invoice_items.should == [invoice_item2]
        end
      end
      context "when multiple invoice items match item id" do
        it "returns an array of all matching invoice_item objects" do
          InvoiceItem.stub(:for_item).and_return([invoice_item, invoice_item3])
          item.invoice_items.should == [invoice_item, invoice_item3]
        end
      end
      context "when no invoice items match item id" do
        it "returns an empty array" do
          InvoiceItem.stub(:for_item).and_return([])
          item.invoice_items.should == []
        end
      end
    end

    describe "#revenue" do
      let(:invoice_item1) { double("invoice_item", :quantity => 1,
                                   :unit_price => 10) }
      let(:invoice_item2) { double("invoice_item", :quantity => 2,
                                   :unit_price => 20) }
      let(:invoice_item3) { double("invoice_item", :quantity => 3,
                                   :unit_price => 30) }
      let(:item) { Fabricate(:item) }

      context "when there are invoice_items for the item" do
        it "returns total revenue for the item" do
          item.stub({:invoice_items => [invoice_item1, invoice_item2, invoice_item3]})
          item.revenue.should == 140
        end
      end
      context "when there are no invoice items for the item" do
        it "returns 0" do
          item.stub({:invoice_items => []})
          item.revenue.should == 0
        end
      end
    end

    describe ".most_revenue(x)" do
      let(:item1) { double("item") }
      let(:item2) { double("item") }
      let(:item3) { double("item") }

      before(:each) do
        item1.stub(:revenue).and_return(1)
        item2.stub(:revenue).and_return(2)
        item3.stub(:revenue).and_return(3)
      end                                            

      context "when number of items is greater than X" do
        it "returns an array of items with the most revenue" do
          Item.stub(:items).and_return([item1, item2, item3])
          Item.most_revenue(2).should == [item3, item2]
        end
      end
      context "when number of items is less than X" do
        it "returns an array of all merchants" do
          Item.stub(:items).and_return([item1, item2])
          Item.most_revenue(3).should == [item2, item1]
        end
      end
      context "when there is only one item" do
        it "returns an array with one item" do
          Item.stub(:items).and_return([item1])
          Item.most_revenue(3).should == [item1]
        end
      end
      context "when there are no items" do
        it "returns an empty array" do
          Item.stub(:items).and_return([])
          Item.most_revenue(3).should == []
        end
      end 
    end

    describe "#quantity" do
      let(:invoice_item1) { double("invoice_item", :quantity => 1) }
      let(:invoice_item2) { double("invoice_item", :quantity => 2) }
      let(:invoice_item3) { double("invoice_item", :quantity => 3) }
      let(:item) { Fabricate(:item) }

      context "when there are invoice_items for the item" do
        it "returns total quantity sold for the item" do
          item.stub({:invoice_items => [invoice_item1, invoice_item2, invoice_item3]})
          item.quantity.should == 6
        end
      end
      context "when there are no invoice items for the item" do
        it "returns 0" do
          item.stub({:invoice_items => []})
          item.quantity.should == 0
        end
      end
    end

    describe ".most_items(x)" do
      let(:item1) { double("item") }
      let(:item2) { double("item") }
      let(:item3) { double("item") }

      before(:each) do
        item1.stub(:quantity).and_return(1)
        item2.stub(:quantity).and_return(2)
        item3.stub(:quantity).and_return(3)
      end                                            

      context "when number of items is greater than X" do
        it "returns an array of items with the most units sold" do
          Item.stub(:items_sold).and_return([item1, item2, item3])
          Item.most_items(2).should == [item3, item2]
        end
      end
      context "when number of items is less than X" do
        it "returns an array of all merchants" do
          Item.stub(:items_sold).and_return([item1, item2])
          Item.most_items(3).should == [item2, item1]
        end
      end
      context "when there is only one item" do
        it "returns an array with one item" do
          Item.stub(:items_sold).and_return([item1])
          Item.most_items(3).should == [item1]
        end
      end
      context "when there are no items" do
        it "returns an empty array" do
          Item.stub(:items_sold).and_return([])
          Item.most_items(3).should == []
        end
      end 
    end

    describe "#quantity_by_day" do
      let(:invoice_item1) { double("invoice_item", :quantity => 1,
                                   :created_at => Date.parse("2012-02-26 20:56:56 UTC")) }
      let(:invoice_item2) { double("invoice_item", :quantity => 2,
                                   :created_at => Date.parse("2012-02-26 21:56:56 UTC")) }
      let(:invoice_item3) { double("invoice_item", :quantity => 4,
                                   :created_at => Date.parse("2012-02-27 20:56:56 UTC")) }
      let(:item) { Fabricate(:item) }
      context "when the item has invoice items" do
        it "returns a hash of dates and total quantity" do
          item.stub({:invoice_items => [invoice_item1, invoice_item2, invoice_item3]})
          item.quantity_by_day.should == Hash[Date.parse("2012-02-26") => 3, Date.parse("2012-02-27") => 4]
        end
      end
      context "when the item has one invoice item" do
        it "returns a hash of one of date and total quantity" do
          item.stub({:invoice_items => [invoice_item1]})
          item.quantity_by_day.should == Hash[Date.parse("2012-02-26") => 1]
        end
      end
      context "when the item has no invoice items" do
        it "returns an empty hash" do
          item.stub({:invoice_items => []})
          item.quantity_by_day.should == {}
        end
      end   
    end

    describe "#best_day" do
      let(:item) { Fabricate(:item) }
      context "when the item has invoice items" do
        it "returns the day with the most items" do
          item.stub(:quantity_by_day).and_return(Hash[Date.parse("2012-02-26") => 3, Date.parse("2012-02-27") => 4])
          item.best_day.should == Date.parse("2012-02-27")
        end
      end
      context "when the item has no invoice items" do
        it "returns nil" do
          item.stub(:quantity_by_day).and_return({})
          item.best_day.should == nil
        end
      end
    end
  end
end
