require 'spec_helper'

describe SalesEngine::Customer do 

  describe ".random" do 
    it "responds" do
      SalesEngine::Customer.should respond_to("random".to_sym)
    end 
  end

  describe "find_by_" do
    attributes = [:id, :first_name, :last_name, :created_at, :updated_at]
    attributes.each do |attribute|
      method_name = "find_by_#{attribute}".to_sym

      it "responds to #{method_name}" do
        SalesEngine::Customer.should respond_to(method_name)
      end
    end
  end

  describe "find_all_by_" do
    attributes = [:id, :first_name, :last_name, :created_at, :updated_at]
    attributes.each do |attribute|
      method_name = "find_all_by_#{attribute}".to_sym

      it "responds to #{method_name}" do
        SalesEngine::Customer.should respond_to(method_name)
      end
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