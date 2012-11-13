require 'spec_helper'

module SalesEngine 
  class MerchantRecordTest
    extend MerchantRecord
  end

  describe MerchantRecord do
    describe "#merchants" do
      it "returns all merchants" do
        MerchantRecordTest.merchants.length.should == 100
      end
    end
  end

  describe ".most_revenue" do
    it "returns merchant with most revenue" do
      MerchantRecordTest.most_revenue(5)[1].name.should == 
        "Ritchie Inc"
    end
  end

  describe "#customers_with_pending_invoices" do
    it "returns all customers with pending invoices" do
      merchant = Merchant.find_by_id(1)
      merchant.customers_with_pending_invoices.length.should == 0
    end
  end

  describe ".revenue(date)" do
    let(:date) { Date.parse '2012-02-20' }
    context "when there are multiple merchants" do
      it "returns the total revenue for all merchants " do
        Merchant.revenue(date).should == 2889301.77
      end
    end
  end
end
