require 'spec_helper'

describe SalesEngine::Merchant do

  let(:test_merchant) { Fabricate(:merchant)}
  
  describe "#items" do 
    context "returns a collection of items" do

      it "contains things which are only items" do
        test_merchant.items.all?{|i| i.is_a? SalesEngine::Item}.should == true
      end

      it "contains items associated with only this merchant" do
        test_merchant.items.all? {|i| 
          i.merchant_id == test_merchant.id}.should == true
      end
    end
  end

  describe ".random" do 
    it "returns one merchant from all the merchants" do
      tester = SalesEngine::Merchant.random 
      tester.is_a?(SalesEngine::Merchant).should == true
    end
  end

  describe "#invoices" do
    context "returns a collection of invoices" do

      it "contains things which are only invoices" do
        test_merchant.invoices.all?{|i| i.is_a? SalesEngine::Invoice}.should == true
      end

      it "contains invoices associated only with this merchant" do
        test_merchant.invoices.all?{|i|
          i.merchant_id == test_merchant.id}.should == true
      end
    end
  end

  describe "#revenue(date=nil)" do
    invoice_1 = Fabricate(:invoice, :total => 2000)
    invoice_2 = Fabricate(:invoice, :total => 1000)
    puts "hello"
    
    # invoice_test
    test_date = "2012-02-02"
    context "returns total revenue for this merchant with no date" do
      
      it "returns a BigDecimal" do
        test_merchant.revenue.is_a?(BigDecimal).should == true
      end

      it "gets the revenue for this merchant" do
        test_merchant.invoices = [invoice_1, invoice_2]
        test_merchant.revenue.should == BigDecimal.new("30.00")
      end
    end

    # context "returns total revenue for this merchant with a date" do
    #   it "returns a BigDecimal" do
    #     test_merchant.revenue(test_date).is_a?(BigDecimal).should == true
    #   end

    #   it "gets the revenue for this merchant on one date" do
    #     test_merchant.revenue.should == BigDecimal.new(20)
    #   end
    # end
  end

  describe "#favorite_customer" do

    it "returns a customer" do
      test_merchant.favorite_customer.should be_a (SalesEngine::Customer)
    end

    it "returns the customer with the most transactions/invoices" do
      customer_1 = Fabricate(:customer)
      customer_1_invoices = [ Fabricate(:invoice, :customer => customer_1, :merchant => test_merchant),
        Fabricate(:invoice, :customer => customer_1, :merchant => test_merchant)]

      customer_2 = Fabricate(:customer)
      customer_2_invoices = [ Fabricate(:invoice, :customer => customer_2, :merchant => test_merchant),
        Fabricate(:invoice, :customer => customer_2, :merchant => test_merchant),
        Fabricate(:invoice, :customer => customer_2, :merchant => test_merchant)]

      customer_3 = Fabricate(:customer)
      customer_3_invoices = [ Fabricate(:invoice, :customer => customer_3, :merchant => test_merchant)]

      test_merchant.invoices = [customer_1_invoices, customer_2_invoices, customer_3_invoices].flatten

      test_merchant.favorite_customer.should == customer_2
    end
  end

  describe "#customers" do
    it "returns the set of associated customers" do
      customer_1 = Fabricate(:customer)
      customer_1_invoices = [ Fabricate(:invoice, :customer => customer_1, :merchant => test_merchant),
        Fabricate(:invoice, :customer => customer_1, :merchant => test_merchant)]

      customer_2 = Fabricate(:customer)
      customer_2_invoices = [ Fabricate(:invoice, :customer => customer_2, :merchant => test_merchant),
        Fabricate(:invoice, :customer => customer_2, :merchant => test_merchant),
        Fabricate(:invoice, :customer => customer_2, :merchant => test_merchant)]

      test_merchant.invoices = [customer_1_invoices, customer_2_invoices].flatten

      test_merchant.customers.should include(customer_1)
      test_merchant.customers.should include(customer_2)
    end
  end

end


