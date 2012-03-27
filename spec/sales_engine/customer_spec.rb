require 'spec_helper'

describe SalesEngine::Customer do
  a = SalesEngine::Customer.new({:id=>3})

  let(:customer) do
    c = Fabricate(:customer)
    puts c.inspect
    c
  end

  let(:customer_with_invoices){ Fabricate(:customer_with_invoices) }


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
      SalesEngine::Customer.find_by_id(3).class.should == SalesEngine::Customer
    end

    it "returns the correct customer id" do
      random_id = rand(100)
      SalesEngine::Customer.find_by_id(random_id).id.should == random_id
    end
  end

  describe ".find_all_by_id" do

    it "returns a array" do
      SalesEngine::Customer.find_all_by_id(3).class.should == Array
    end
  end

  describe "#invoices" do

    # it "returns an array" do
    #   puts customer.invoices.inspect
    #   customer.invoices.class.should == Array
    # end

    it "returns a collection of invoices" do
      customer_with_invoices.invoices.should be_a(Enumerable)
    end

    # it "returns invoice objects" do
    #   customer.invoices[0].class.should == SalesEngine::Invoice
    # end

  end
end