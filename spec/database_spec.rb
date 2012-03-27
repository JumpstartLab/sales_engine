require 'spec_helper'

describe SalesEngine::Database do
  let(:sqlite_db) { SQLite3::Database.new('data/integration_test.sqlite')}

  before(:all) do
    SalesEngine::Database.instance.db = sqlite_db
  end

  describe "#transactions_by_customer" do
    context "transactions for a customer exist" do
      it "returns a transaction array" do
        rows = SalesEngine::Database.instance.transactions_by_customer(1)
        rows.length.should == 8
      end
    end

    context "transactions for a customer do not exist" do
      it "returns a empty array" do
        rows = SalesEngine::Database.instance.transactions_by_customer(1000)
        rows.should == [] 
      end
    end
  end
end
