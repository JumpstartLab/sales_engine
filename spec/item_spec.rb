require 'spec_helper'
require './lib/item'
require './lib/database'
require './lib/merchant'
require './lib/invoice_item'


describe Item do
  describe ".random" do
    context "when database has items loaded" do
      before(:each) do
        @items = 10.times.collect { mock(Item) } 
        Database.stub(:items).and_return(@items)
      end

      it "returns a random object from items array" do
        Random.stub(:rand).and_return(5)
        Item.random.should == @items[5]
      end

      it "returns a item" do
        Item.random.is_a?(mock(Item).class).should == true
      end
    end

    context "when database has no items" do
      it "returns nil" do
        Item.random.should == nil
      end
    end
  end

  describe ".find_by" do
    let(:item) { mock(Item) }
    let(:item2) { mock(Item) }
    let(:item3) { mock(Item) }
    let(:duplicate_item) { mock(Item) }
    let(:items) { [item, item2, item3, duplicate_item] }

    before(:each) do
      item.stub(:id).and_return(1)
      item2.stub(:id).and_return(2)
      item3.stub(:id).and_return(3)
      duplicate_item.stub(:id).and_return(1)
    end

    it "calls find_by attribute" do
      Database.stub(:items).and_return(items)
      Item.find_by_id(2).should == item2
    end
  end

  describe ".find_all_by" do
    let(:item) { mock(Item) }
    let(:item2) { mock(Item) }
    let(:duplicate_item) { mock(Item) }
    let(:items) { [item, item2, duplicate_item] }

    before(:each) do
      item.stub(:id).and_return(1)
      item2.stub(:id).and_return(2)
      duplicate_item.stub(:id).and_return(1)
    end
    
    it "calls find_all_by attribute" do
      Database.stub(:items).and_return(items)
      Item.find_all_by_id(1).should == [item, duplicate_item]
    end
  end

  describe "method missing" do
    it "invokes the normal no method error" do
      expect{Item.foo}.should raise_error
    end
  end

  describe "respond to" do
    let(:item) { Item.new(1, "", "", 0, 0, Date.today, Date.today)}
    it "returns true for find_by" do
      item.respond_to?("find_by_id").should == true
    end
    it "returns true for find_all_by" do
      item.respond_to?("find_all_by_id").should == true
    end
    it "returns false for a method that doesn't exist" do
      item.respond_to?("foo").should == false
    end
  end

  describe ".merchant" do
    let(:merchant) { mock(Merchant) }
    let(:merchant2) { mock(Merchant)}
    let(:item) { Item.new(1, "", "", 0, 1, Date.today, Date.today)}
    it "returns the merchant with the correct id" do
      merchant.stub(:id).and_return(1)
      merchant2.stub(:id).and_return(2)
      Database.stub(:merchants).and_return([merchant, merchant2])
      item.merchant.should == merchant
    end
  end

  describe ".invoice_items" do
    let(:item) { Item.new(1, "", "", 0, 1, Date.today, Date.today)}
    let(:invoice_item) { mock(InvoiceItem) }
    let(:invoice_item2) { mock(InvoiceItem) }
    let(:invoice_item3) { mock(InvoiceItem) }

    before(:each) do
      invoice_item.stub(:item_id).and_return(1)
      invoice_item2.stub(:item_id).and_return(2)
      invoice_item3.stub(:item_id).and_return(1)
      invoice_items = [invoice_item, invoice_item2, invoice_item3]
      Database.stub(:invoice_items).and_return(invoice_items)
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