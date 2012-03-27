require 'spec_helper'

describe SalesEngine::Database do
  let(:sqlite_db) { SQLite3::Database.new('data/integration_test.sqlite')}

  before(:all) do
    SalesEngine::Database.instance.db = sqlite_db
  end

  describe "#merchants" do
    it "returns all merchants" do
      SalesEngine::Database.instance.merchants.length.should == 100
    end
  end

  describe "#invoices" do
    it "returns all invoices" do
      SalesEngine::Database.instance.invoices.length.should == 4985
    end
  end

  describe "#items" do
    it "returns all items" do
      SalesEngine::Database.instance.items.length.should == 2415
    end
  end

  describe "#customers" do
    it "returns all customers" do
      SalesEngine::Database.instance.customers.length.should == 1000
    end
  end

  describe "#transactions" do
    it "returns all transactions" do
      SalesEngine::Database.instance.transactions.length.should == 4985
    end
  end

  describe "#invoice_items" do
    it "returns all invoice items" do
      SalesEngine::Database.instance.invoice_items.length.should == 22264
    end
  end

  describe "#invoice_items_by_merchant" do
    context "invoice items for merchant exists" do
      it "returns a array of invoice items" do
        rows = SalesEngine::Database.instance.invoice_items_by_merchant(1)
        rows.length.should == 215 
      end
    end

    context "invoice items for merchant doesn't exists" do
      it "returns an empty array" do
        rows = SalesEngine::Database.instance.invoice_items_by_merchant(1000)
        rows.length.should == 0 
      end
    end
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

  describe "#popular_customers" do
    let(:rows) { SalesEngine::Database.instance.popular_customers(1) }

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
