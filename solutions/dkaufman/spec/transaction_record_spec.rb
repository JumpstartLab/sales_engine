require "spec_helper"
require "sales_engine/transaction_record"

module SalesEngine
  class TransactionRecordTest 
    extend TransactionRecord 
  end

  describe "#transactions" do
    it "returns all transactions" do
      TransactionRecordTest.transactions.length.should == 4985
    end
  end

  describe ".for_customer" do
    context "transactions for a customer exist" do
      it "returns a transaction array" do
        rows = TransactionRecordTest.for_customer(1)
        rows.length.should == 8
      end
    end

    context "transactions for a customer do not exist" do
      it "returns a empty array" do
        rows = TransactionRecordTest.for_customer(1000)
        rows.should == [] 
      end
    end
  end

  describe ".insert" do
    let (:transaction_hash) { { :invoice_id => 1, :credit_card_number => "2222", 
                  :credit_card_expiration_date => "3333", :result => "result" } } 

    
    before(:all) do
      @old_transactions = TransactionRecordTest.transactions
      @id = TransactionRecordTest.insert(transaction_hash)
      @new_transactions = TransactionRecordTest.transactions
    end

    it "executes insert query" do
      clean_date = SalesEngine::Database.get_dates[1]
      sql = "insert into transactions values (?, ?, ?, ?, ?, ?, ?, ?, ?)"
      Database.instance.db.should_receive(:execute).with(sql, nil,
       transaction_hash[:invoice_id], transaction_hash[:credit_card_number],
       transaction_hash[:credit_card_expiration_date], transaction_hash[:result],
       DateTime.now.to_s, DateTime.now.to_s, clean_date, clean_date)    
       TransactionRecordTest.insert(transaction_hash)
    end

    it "adds a new transaction to the database" do
      @new_transactions.length.should == @old_transactions.length + 1
    end

    it "increments transaction id" do
      @id.should == 4986
    end
  end
end
