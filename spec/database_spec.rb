require 'spec_helper'

describe SalesEngine::Database do
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

  describe "#customers_by_merchant" do
    context "customers for merchant exist" do
      it "returns a array of customers" do
        rows = SalesEngine::Database.instance.customers_by_merchant(1)
        rows.length.should == 51 
      end
    end

    context "customers for merchant doesn't exists" do
      it "returns an empty array" do
        rows = SalesEngine::Database.instance.customers_by_merchant(1000)
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

  describe "#insert_transaction" do
    let (:transaction_hash) { { :invoice_id => 1, :credit_card_number => "2222", 
                  :credit_card_expiration_date => "3333", :result => "result" } } 

    
    before(:all) do
      @old_transactions = SalesEngine::Database.instance.transactions
      @id = SalesEngine::Database.instance.insert_transaction(transaction_hash)
      @new_transactions = SalesEngine::Database.instance.transactions
    end

    it "executes insert query" do
      clean_date = SalesEngine::Database.get_dates[1]
      sql = "insert into transactions values (?, ?, ?, ?, ?, ?, ?, ?, ?)"
      SalesEngine::Database.instance.db.should_receive(:execute).with(sql, nil,
       transaction_hash[:invoice_id], transaction_hash[:credit_card_number],
       transaction_hash[:credit_card_expiration_date], transaction_hash[:result],
       DateTime.now.to_s, DateTime.now.to_s, clean_date, clean_date)    
       SalesEngine::Database.instance.insert_transaction(transaction_hash)
    end

    it "adds a new transaction to the database" do
      @new_transactions.length.should == @old_transactions.length + 1
    end

    it "increments transaction id" do
      @id.should == 4986
    end
  end
end
