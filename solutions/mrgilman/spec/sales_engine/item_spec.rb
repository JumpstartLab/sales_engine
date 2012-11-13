require 'spec_helper'

describe SalesEngine::Item do

  describe ".random" do
    it "returns an item" do
      SalesEngine::Item.random.class.should == SalesEngine::Item
    end

    it "returns different items on two calls" do
      y = SalesEngine::Item.random
      z = SalesEngine::Item.random

      while y == z
        y = SalesEngine::Item.random
        z = SalesEngine::Item.random
      end

      y should_not = z

    end
  end

  describe ".find_by_id" do
    id = rand(2000) + 1
    it "returns an item" do
      SalesEngine::Item.find_by_id(id).class.should == SalesEngine::Item
    end
  end

  describe ".find_all_by_id" do
    id = rand(2000) + 1
    it "returns an array" do
      SalesEngine::Item.find_all_by_id(id).class.should == Array
    end

    it" returns an array with items" do
      SalesEngine::Item.find_all_by_id(id).each do |item|
        item.class.should == SalesEngine::Item
      end
    end
  end

  describe "#item_revenue" do
    item1 = SalesEngine::Item.random

    it "returns a BigDecimal" do
      item1.item_revenue.class.should == BigDecimal
    end
  end

  describe ".most_revenue(x)" do
    x = rand(20) + 1 
    it "returns an array" do
      SalesEngine::Item.most_revenue(x).class.should ==Array
    end

    it "returns an array of items" do
      SalesEngine::Item.most_revenue(x).each do |item|
        item.class.should == SalesEngine::Item
      end
    end

    it "returns an array of length x" do
      SalesEngine::Item.most_revenue(x).length.should == x
    end
  end


  describe ".most_items(x)" do
    x = rand(20) + 1 
    it "returns an array" do
      SalesEngine::Item.most_items(x).class.should ==Array
    end

    it "returns an array of items" do
      SalesEngine::Item.most_items(x).each do |item|
        item.class.should == SalesEngine::Item
      end
    end

    it "returns an array of length x" do
      SalesEngine::Item.most_items(x).length.should == x
    end
  end

  describe "#best_day" do
    item1 = SalesEngine::Item.random
    it "if the item has a best day, returns a Date object" do
      if item1.best_day
        item1.best_day.class.should == Date
      end
    end
  end
end