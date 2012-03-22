require 'spec_helper'

describe SalesEngine::Customer do 

  describe ".random" do 
    it "returns a random instance of Customer" do
      result = Customer.new 
      result.class.should == Customer.class 
    end 
  end

  describe "#invoices" do 
    it "returns a collection of invoice instances for a specific customer" do 
      result == Customer.new 
      result.invoices.class.should == invoice.class 
    end 
  end 

  describe "#transactions" do 
    it "returns an array of transaction instances for a specific customer" do
      result == Customer.new 
      result.transactions.class.should == transaction.class
    end 
  end 

  describe "#favorite_merchant" do 
    it "returns an instance of the merchant at which customer has most transactions" do 
    end
  end
end