require './lib/item'
require './lib/database'
require 'spec_helper'

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
        puts Item.random.inspect
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
end