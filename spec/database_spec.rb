require 'spec_helper'

describe SalesEngine::Database do
#  let(:sqlite_db) { SQLite3::Database.new('data/integration_test.sqlite')}
   let(:sqlite_db) { SQLite3::Database.new(':memory:')}

  before(:all) do
    Loader.new(sqlite_db).load
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

  describe "#insert_invoice" do
    let (:invoice_hash) { { :customer_id => 1, :merchant_id => 2, 
                  :status => "shipped" } } 
    
    before(:all) do
      @old_invoices = SalesEngine::Database.instance.invoices
      @id = SalesEngine::Database.instance.insert_invoice(invoice_hash)
      @new_invoices = SalesEngine::Database.instance.invoices
    end

    it "database execute insert query" do
      clean_date = SalesEngine::Database.get_dates[1]
      sql = "insert into invoices values (?, ?, ?, ?, ?, ?, ?, ?)"
      sqlite_db.should_receive(:execute).with(sql, nil,
                               invoice_hash[:customer_id], invoice_hash[:merchant_id],
                               invoice_hash[:status], DateTime.now.to_s,
                               DateTime.now.to_s, clean_date, clean_date)
      SalesEngine::Database.instance.insert_invoice(invoice_hash)
    end

    it "adds a new invoice to the database" do
      @new_invoices.length.should == @old_invoices.length + 1
    end

    it "increments invoice id" do
      @id.should == 4986
    end
  end

  describe "#insert_invoice_item" do
    let (:invoice_item_hash) { { :item_id => 1, :invoice_id => 2, 
                  :quantity => 2, :unit_price => 3 } } 
    
    before(:all) do
      @old_invoice_items = SalesEngine::Database.instance.invoice_items
      @id = SalesEngine::Database.instance.insert_invoice_item(invoice_item_hash)
      @new_invoice_items = SalesEngine::Database.instance.invoice_items
    end

    it "executes insert query" do
      clean_date = SalesEngine::Database.get_dates[1]
      sql = "insert into invoice_items values (?, ?, ?, ?, ?, ?, ?, ?, ?)"
      sqlite_db.should_receive(:execute).with(sql, nil,
       invoice_item_hash[:item_id], invoice_item_hash[:invoice_id],
       invoice_item_hash[:quantity], invoice_item_hash[:unit_price], 
       DateTime.now.to_s,DateTime.now.to_s, clean_date, clean_date)    
      SalesEngine::Database.instance.insert_invoice_item(invoice_item_hash)
    end


    it "adds a new invoice item to the database" do
      @new_invoice_items.length.should == @old_invoice_items.length + 1
    end

    it "increments invoice_item id" do
      @id.should == 22265
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
      sqlite_db.should_receive(:execute).with(sql, nil,
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
