require './lib/customer.rb'

describe Customer do
  before(:all) do
    let(:a) { Customer.new({id=>"3"}) }
    let(:b) { Customer.new({}) }
    let(:c) { Customer.new({}) }
    let(:d) { Customer.new({}) }
    let(:e) { Customer.new({}) }
  end


  describe ".random" do
    it "returns a customer" do
      Customer.random.class.should == Customer
    end

    it "returns different customers on two calls" do
      Customer.random.should_not == Customer.random
    end
  end

  describe ".find_by_id" do

    it "returns a customer" do
      Customer.find_by_id("3").class.should == Customer
    end

    it "returns the correct customer id" do
      Customer.find_by_id("3").id.should == "3"
    end

    it "returns the correct customer" do
      Customer.find_by_id("3").should == a
    end
  end

  describe ".find_all_by_id" do

    it "returns a array" do
      Customer.find_all_by_id("3").class.should == Array
    end
  end
end