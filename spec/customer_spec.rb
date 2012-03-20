require './customer.rb'

describe Customer do

  describe ".random" do
    a = Customer.new({})
    b = Customer.new({})
    c = Customer.new({})
    d = Customer.new({})
    e = Customer.new({})
    it "returns a customer" do
      Customer.random.class.should == Customer
    end

    it "returns different customers on two calls" do
      Customer.random.should_not == Customer.random
    end
  end
  describe ".find_by_cust_id" do
    a = Customer.new({:cust_id=>3})
    it "returns a customer" do
      Customer.find_by_cust_id(3).class.should == Customer
    end
    
    it "returns different customers on two calls" do
      Customer.find_by_cust_id(3).should == a
    end
  end
end