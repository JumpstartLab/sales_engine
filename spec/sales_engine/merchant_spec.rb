require 'spec_helper'

describe SalesEngine::Merchant do

  let(:test_merchant) { Fabricate(:merchant) }
  
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

  describe "#revenue" do
    context "returns total revenue for this merchant" do
      it "returns a BigDecimal" do
        test_merchant.revenue.is_a?(BigDecimal).should == true
      end

      it "returns a BigDecimal to two decimal points" do
        # test_merchant.should_receive(:invoices)
        # test_merchant.revenue
      end

      it "gets the invoice items for each invoice" do
        # test_merchant.invoices.should_receive(:invoice_items)
        # test_merchant.revenue
      end

      it "correctly tallies each item on each invoice items" do
        # call the revenue method on test_merchant
        # it should equal what we put in the stub
      end
    end
  end
end


