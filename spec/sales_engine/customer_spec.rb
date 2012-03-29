require 'spec_helper'

describe SalesEngine::Customer do

  a = SalesEngine::Customer.new({:id=>3})
  b = SalesEngine::Customer.new({:first_name=>"FirstName"})

  # let(:customer){Fabricate(:customer)}

  # let(:customer_with_invoices){ Fabricate(:customer_with_invoices) }

  # let(:customer_with_merchants){ Fabricate(:customer_with_merchants) }


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

    it "returns an array" do
      SalesEngine::Customer.find_all_by_id(3).class.should == Array
    end
  end

  describe ".find_by_first_name" do

    it "finds customers with matching first name" do
      SalesEngine::Customer.find_by_first_name("Charles").first_name.should == "Charles"
    end
  end

    it "finds a customer" do
      SalesEngine::Customer.find_by_first_name("Charles").class.should == SalesEngine::Customer
    end

  describe ".find_all_by_last_name" do

    it "returns an array" do
      SalesEngine::Customer.find_all_by_last_name("Jewess").class.should == Array
    end

    it "returns an array of customers" do
      SalesEngine::Customer.find_all_by_last_name("Jewess").each do |cust|
        cust.class.should == SalesEngine::Customer
      end
    end

    it "returns an array of customers with the same last name" do
      test_last_name = "Mercedes"
      SalesEngine::Customer.find_all_by_last_name(test_last_name).each do |cust|
        cust.last_name.should == test_last_name
      end
    end
  end

  describe "#favorite_merchant" do
    it "returns a merchant if customer has associated merchants" do
      customer1 = SalesEngine::Customer.random
      if customer1.favorite_merchant.nil? == false
        customer1.favorite_merchant.class.should == SalesEngine::Merchant
      else
        customer1.favorite_merchant.should == nil
      end
    end
  end

  describe "#transactions" do
    it "returns an array" do
      SalesEngine::Customer.random.transactions.class.should == Array
    end

    it "returns an array of transaction objects" do
      SalesEngine::Customer.random.transactions.each do |trans|
        trans.class == SalesEngine::Transaction
      end
    end
  end




  describe "#invoices" do

    it "returns a collection of invoices" do
      SalesEngine::Customer.random.invoices.should be_a(Enumerable)
    end

    it "returns invoice objects" do
      customer1 = SalesEngine::Customer.random
      if customer1.invoices != []
        customer1.invoices[0].class.should == SalesEngine::Invoice
      else
        customer1.invoices.should == []
      end
    end
  end

  describe "#invoice_ids" do
    customer1 = SalesEngine::Customer.random
    it "returns an array" do
      customer1.invoice_ids.should be_a(Array)
    end
  end 

  # describe "#merchants_array" do
  #   it "returns an array" do
  #     customer 
  # end
end