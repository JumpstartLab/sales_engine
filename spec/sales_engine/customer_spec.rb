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

    it "returns the merchant with the most transactions/invoices" do
      merchant_1 = Fabricate(:merchant)
      merchant_1_invoices = [ Fabricate(:invoice, :merchant => merchant_1, :customer => test_customer),
      Fabricate(:invoice, :merchant => merchant_1, :customer => test_customer) ]
     
      merchant_2 = Fabricate(:merchant)
      merchant_2_invoices = [ Fabricate(:invoice, :merchant => merchant_2, :customer => test_customer),
      Fabricate(:invoice, :merchant => merchant_2, :customer => test_customer),
      Fabricate(:invoice, :merchant => merchant_2, :customer => test_customer) ]
     
      merchant_3 = Fabricate(:merchant)
      merchant_3_invoices = [ Fabricate(:invoice, :merchant => merchant_3, :customer => test_customer) ]

      test_customer.invoices = [merchant_1_invoices, merchant_2_invoices, merchant_3_invoices].flatten
      test_customer.favorite_merchant.should == merchant_2
    end
  end

end
