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
    it "returns customer with pending invoices" do
      merchant = Fabricate(:merchant)
      merchant.customers_with_pending_invoices[0].last_name.should == 
        "Lemke"
    end
  end
end
