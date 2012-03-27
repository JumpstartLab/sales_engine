require './spec/spec_helper'

describe SalesEngine::Customer do
  describe ".get_customers" do
    before(:all) { SalesEngine::Customer.get_customers }
    it "stores records from customer.csv" do
      SalesEngine::Customer.records.map(&:class).uniq.should == [SalesEngine::Customer]
    end
    {id: 1, first_name: "Eliezer",
      last_name: "Lemke"}.each do |attribute, value|
        it "records #{attribute}" do
          SalesEngine::Customer.records.first.send(attribute).should == value
        end
      end
      it "stores the raw CSV for each merchant" do
        SalesEngine::Customer.records.first.raw_csv.should be_an Array
      end

      it "stores headers on the Merchant class" do
        SalesEngine::Customer.csv_headers.should be_an Array
      end
    end

    context "instance methods" do
      let(:customer) { SalesEngine::Customer.find_by_id(1) }
      describe "#invoices" do
        it "returns invoices" do
          customer.invoices.should_not be_empty
          customer.invoices.first.should be_a(SalesEngine::Invoice)
        end
        it "returns all invoices with the customer_id of the instance" do
          customer.invoices.size.should == 8
        end
      end
    end
    context "business intelligence methods" do
      describe "#transactions" do
        it "returns an array of Transactions" do
          SalesEngine::Customer.find_by_id(1).transactions.should be_an Array
          SalesEngine::Customer.find_by_id(1).transactions.first.should be_a SalesEngine::Transaction
        end
        it "returns an array of Transactions associated with the customer" do
          SalesEngine::Customer.find_by_id(1).transactions.size.should == 8
        end
      end
    #invoices already implemented
    describe "#favorite_merchant" do
      it "returns the merchant from which the customer has purchased the most times" do
        SalesEngine::Customer.find_by_id(10).favorite_merchant.should == SalesEngine::Merchant.find_by_id(59)
      end
    end
  end
  context "extensions" do
    describe "#days_since_activity" do
      it "returns a count of the days since the customer's last transaction" do
        DateTime.stub(:now => DateTime.parse("Feb 29, 2012"))
        SalesEngine::Customer.find_by_id(1).days_since_activity.should be_an Integer
        SalesEngine::Customer.find_by_id(1).days_since_activity.should == 3

      end
    end
    describe "#pending_invoices" do
      context "when there are no pending invoices" do
        it "returns an empty array" do
          SalesEngine::Customer.find_by_id(1).pending_invoices.should be_an Array
          SalesEngine::Customer.find_by_id(1).pending_invoices.should == []
        end
      end
      context "when there are pending invoices" do
        it "returns an array of the pending invoices" do
          bad_transaction = double("transaction")
          bad_transaction.stub(:result => "pending")
          SalesEngine::Customer.find_by_id(1).invoices.first.stub(:transactions => [bad_transaction])

          SalesEngine::Customer.find_by_id(1).pending_invoices.should == [SalesEngine::Customer.find_by_id(1).invoices.first]
        end
      end
    end
    describe ".most_items" do
      it "returns a customer" do
        SalesEngine::Customer.most_items.should be_a SalesEngine::Customer
      end
      it "returns the customer who has purchased the most items" do
        SalesEngine::Customer.most_items.should == SalesEngine::Customer.find_by_id(75)
      end
    end
    describe ".most_revenue" do
      it "returns a customer" do
        SalesEngine::Customer.most_revenue.should be_a SalesEngine::Customer
      end
      it "returns the customer who has generated the most total revenue" do
        SalesEngine::Customer.most_revenue.should == SalesEngine::Customer.find_by_id(240)
      end
    end
  end
end

#id,first_name,last_name,created_at,updated_at
#1,Lemke,Eliezer,2012-02-26 20:56:56 UTC,2012-02-26 20:56:56 UTC