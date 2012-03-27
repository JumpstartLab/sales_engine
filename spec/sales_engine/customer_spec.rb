require 'spec_helper'

describe SalesEngine::Customer do

  let(:test_customer){Fabricate(:customer)}

  describe "#invoices" do
    context "returns a collection of invoices" do
      it "contains things which are only invoices" do
        test_customer.invoices.all?{|i| i.is_a? SalesEngine::Invoice}.should == true
      end

      it "contains invoices associated with only this merchant" do
        test_customer.invoices.all? {|i|
          i.customer_id == test_customer.id}.should == true
      end
    end
  end

  describe ".random" do
    it "returns one customer" do
      SalesEngine::Customer.random.should be_a SalesEngine::Customer
    end
  end

  describe "#transactions" do
    it "returns an array of transactions" do
      test_customer.transactions.all?{|i| i.is_a? SalesEngine::Transaction}.should == true
    end

    it "returns transactions associated with this customer" do
      # Go through every transaction returned
        # Check if it is associated with the test_customer id 
    end
  end

  describe "#favorite_merchant" do
    it "returns a merchant" do
      test_customer.favorite_merchant.should be_a SalesEngine::Merchant
    end
  end

end
