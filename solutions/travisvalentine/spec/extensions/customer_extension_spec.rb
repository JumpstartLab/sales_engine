require 'spec_helper'

describe SalesEngine::Customer, customer: true do
  context "extensions" do

    describe "#days_since_activity" do
      it "returns a count of the days since the customer's last transaction" do
        DateTime.stub(:now => DateTime.parse("March 29, 2012"))
        Date.stub(:today => Date.parse("March 29, 2012"))
        days_since = SalesEngine::Customer.find_by_id(1).days_since_activity

        (days_since >= 3 || days_since <= 4).should be_true
      end
    end

    describe "#pending_invoices" do
      let(:pending) { SalesEngine::Customer.find_by_id(2).pending_invoices }
      context "when there are no pending invoices" do
        it "returns an empty array" do
          pending.should == []
        end
      end
      context "when there are pending invoices" do
        let(:first_invoice) { SalesEngine::Customer.find_by_id(2).invoices.first }
        it "returns an array of the pending invoices" do
          bad_transaction = SalesEngine::Transaction.random
          bad_transaction.stub(:result => "failed")
          first_invoice.stub(:transactions => [bad_transaction])

          pending.should == [first_invoice]
        end
      end
    end

    describe ".most_items" do
      it "returns the customer who has purchased the most items" do
        SalesEngine::Customer.most_items.id.should == 622
      end
    end

    describe ".most_revenue" do
      it "returns the customer who has generated the most total revenue" do
        SalesEngine::Customer.most_revenue.id.should == 601
      end
    end
  end
end