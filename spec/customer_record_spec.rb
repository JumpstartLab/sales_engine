require 'spec_helper'
require 'sales_engine/customer_record'

module SalesEngine
  class CustomerRecordTest
    extend CustomerRecord
  end

  describe "#customers" do
    it "returns all customers" do
      CustomerRecordTest.customers.length.should == 1000
    end
  end

  describe "#customers_by_merchant" do
    context "customers for merchant exist" do
      it "returns a array of customers" do
        rows = CustomerRecordTest.customers_by_merchant(1)
        rows.length.should == 51 
      end
    end

    context "customers for merchant doesn't exists" do
      it "returns an empty array" do
        rows = CustomerRecordTest.customers_by_merchant(1000)
        rows.length.should == 0 
      end
    end
  end

  describe "#popular_customers" do
    let(:rows) { CustomerRecordTest.popular_customers(1) }

    context "merchant has transactions" do
      it "returns a hash with customer_ids => transaction count" do
        rows.length.should == 49
      end

      it "returns customer 959 with 2 transactions" do
        rows[959].should == 2
      end
    end
  end
end
