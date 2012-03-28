require 'spec_helper'

describe SalesEngine::Database do
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

  describe "#invoices_by_merchant" do
    context "invoices for merchant exist" do
      it "returns a array of invoices" do
        rows = SalesEngine::Database.instance.invoices_by_merchant(1)
        rows.length.should == 51 
      end
    end

    context "invoices for merchant doesn't exists" do
      it "returns an empty array" do
        rows = SalesEngine::Database.instance.invoices_by_merchant(1000)
        rows.length.should == 0 
      end
    end
  end

  describe "#invoices_by_merchant_for_date" do
    context "invoices for merchant for that date exist" do
      it "returns a array of invoices" do
        rows = SalesEngine::Database.instance.invoices_by_merchant_for_date(1, Date.parse("2012-02-19"))
        rows.length.should == 4
      end
    end

    context "invoices for merchant for that date don't exist" do
      it "returns an empty array" do
        rows = SalesEngine::Database.instance.invoices_by_merchant_for_date(1, Date.parse("2013-02-19"))
        rows.length.should == 0
      end
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
      SalesEngine::Database.instance.db.should_receive(:execute).with(sql, nil,
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
