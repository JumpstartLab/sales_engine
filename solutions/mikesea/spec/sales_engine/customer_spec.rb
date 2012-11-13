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

      it "returns multiple customers" do
        customers = SalesEngine::Customer.find_all_by_first_name "Sasha"
        customers.should have(2).customers
      end
    end
  end

  describe "#invoices" do 
    let (:customer) { SalesEngine::Customer.random }
    it "responds to the method" do 
      customer.should respond_to("invoices".to_sym)
    end
    it "returns invoices with the same customer id as the example" do 
      invoices = customer.invoices 
      invoices.collect do |invoice| 
        invoice.customer_id.should == customer.id 
      end
    end
  end

  describe "#transactions" do 
    let (:customer) { SalesEngine::Customer.find_by_id(24)}
    it "responds to the method" do 
      customer.should respond_to("transactions".to_sym)
    end 

    it "returns transactions with the same customer id as the example" do
      transactions = customer.transactions
      #invoices = customer.invoices
      transactions.select do |transaction|
        transaction.customer_id.should == 24
      end
    end 
  end

  describe "#favorite_merchant" do 
    let (:customer) { SalesEngine::Customer.find_by_id(13) }
    it "responds to the method" do 
      customer.should respond_to("favorite_merchant".to_sym)
    end 

    it "returns an instance of the merchant at which customer has most transactions" do 
      merchant = customer.favorite_merchant 
      merchant.id.should == 76
    end 
  end
end