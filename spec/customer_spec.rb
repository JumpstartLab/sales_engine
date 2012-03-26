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
  end

#id,first_name,last_name,created_at,updated_at
#1,Lemke,Eliezer,2012-02-26 20:56:56 UTC,2012-02-26 20:56:56 UTC