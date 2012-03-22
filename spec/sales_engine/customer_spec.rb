require 'spec_helper'

describe SalesEngine::Customer do
  a = SalesEngine::Customer.new({:id=>"3"})
  b = SalesEngine::Customer.new({})
  c = SalesEngine::Customer.new({})
  d = SalesEngine::Customer.new({})
  e = SalesEngine::Customer.new({})


  describe ".random" do
    it "returns a customer" do
      SalesEngine::Customer.random.class.should == SalesEngine::Customer
    end

    it "returns different customers on two calls" do
      y = SalesEngine::Customer.random
      z = SalesEngine::Customer.random

      while y == z
        y = SalesEngine::Customer.random
        z = SalesEngine::Customer.random
      end

      y should_not = z

    end
  end

  describe ".find_by_id" do

    it "returns a customer" do
      SalesEngine::Customer.find_by_id("3").class.should == SalesEngine::Customer
    end

    it "returns the correct customer id" do
      SalesEngine::Customer.find_by_id("3").id.should == "3"
    end

    it "returns the correct customer" do
      #a = Customer.new({:id=>"3"})
      SalesEngine::Customer.find_by_id("3").id.should == a.id
    end
  end

  describe ".find_all_by_id" do

    it "returns a array" do
      SalesEngine::Customer.find_all_by_id("3").class.should == Array
    end
  end

end