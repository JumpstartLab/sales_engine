require 'spec_helper'

describe SalesEngine::Invoice do
  let(:se) { SalesEngine::Database.instance}
  let(:invoice_1) { Fabricate(:invoice) }
  let(:invoice_2) { Fabricate(:invoice) }
  let(:invoice_3) { Fabricate(:invoice) }
  let(:item_1) { Fabricate(:item) }
  let(:item_2) { Fabricate(:item) }
  let(:item_3) { Fabricate(:item) }
  let(:item_4) { Fabricate(:item) }
  let(:invoice_item_1) { Fabricate(:invoice_item, :invoice_id => invoice_1.id, :item_id => item_1.id) }
  let(:invoice_item_2) { Fabricate(:invoice_item, :invoice_id => invoice_2.id, :item_id => item_2.id) }
  let(:invoice_item_3) { Fabricate(:invoice_item, :invoice_id => invoice_1.id, :item_id => item_3.id) }
  let(:invoice_item_4) { Fabricate(:invoice_item, :invoice_id => invoice_1.id, :item_id => item_4.id) }
  let(:customer_1) { Fabricate(:customer) }
  let(:customer_2) { Fabricate(:customer) }
  let(:merchant_1) { Fabricate(:merchant) }
  let(:merchant_2) { Fabricate(:merchant) }
  let(:merchant_3) { Fabricate(:merchant) }
  let(:transaction_1) { Fabricate(:transaction, :invoice_id => invoice_1.id) }
  let(:transaction_2) { Fabricate(:transaction, :invoice_id => invoice_2.id) }
  let(:transaction_3) { Fabricate(:transaction, :invoice_id => invoice_1.id) }
  let(:transaction_4) { Fabricate(:transaction) }

  before(:each) do
    se.clear_all_data
    se.add_to_list(invoice_1)
    se.add_to_list(invoice_2)
    se.add_to_list(invoice_3)
    se.add_to_list(item_1)
    se.add_to_list(item_2)
    se.add_to_list(item_3)
    se.add_to_list(item_4)      
    se.add_to_list(invoice_item_1)
    se.add_to_list(invoice_item_2)
    se.add_to_list(invoice_item_3)
    se.add_to_list(invoice_item_4)
    se.add_to_list(customer_1)
    se.add_to_list(customer_2)
    se.add_to_list(merchant_1)
    se.add_to_list(merchant_2)
    se.add_to_list(merchant_3)
    se.add_to_list(transaction_1)
    se.add_to_list(transaction_2)
    se.add_to_list(transaction_3)
    se.add_to_list(transaction_4)
  end

  describe "#total_revenue" do
    context "no transactions failed" do
      it "returns the total revenue for an invoice" do
        invoice_1.total_revenue.should == 3
      end
    end

    context "one transaction failed but another was successful" do
      it "returns the total revenue for an invoice" do
        transaction_1.result = "Failed"
        invoice_1.total_revenue.should == 3
      end
    end

    context "one transaction failed but another was successful" do
      it "returns the total revenue for an invoice" do
        transaction_1.result = "Failed"
        transaction_3.result = "Failed"
        invoice_1.total_revenue.should == 0
      end
    end

    context "invoice item has a quantity greater than 1" do
      it "returns the total revenue for an invoice" do
        invoice_item_2.unit_price = 4
        invoice_item_2.quantity   = 3
        invoice_2.total_revenue.should == 12
      end
    end

  end

  describe ".random" do
    context "when invoice exist in the datastore" do
      it "returns a random invoice record" do
        se.invoices.include?(SalesEngine::Invoice.random).should be_true
      end
    end

    context "when there are no invoices in the datastore" do
      it "returns nil" do
        se.clear_all_data
        SalesEngine::Invoice.random.should be_nil
      end
    end
  end

  describe ".find_by_id" do
    context "when invoices exist in the datastore" do
      it "returns the correct invoice record that matches the id" do
        SalesEngine::Invoice.find_by_id(invoice_2.id).should == invoice_2
      end

      it "returns nothing if no invoice records match the id" do
        SalesEngine::Invoice.find_by_id(100).should be_nil
      end
    end

    context "when there are no invoices in the datastore" do
      it "returns nothing" do
        se.clear_all_data
        SalesEngine::Invoice.find_by_id(invoice_1.id).should be_nil
      end
    end
  end

  describe ".find_by_customer_id" do
    before(:each) do
      invoice_1.customer_id = customer_1.id        
      invoice_2.customer_id = customer_2.id
    end

    context "when invoices exist in the datastore" do
      it "returns the correct invoice record that matches the customer_id" do
        SalesEngine::Invoice.find_by_customer_id(customer_2.id).should == invoice_2
      end

      it "returns nothing if no invoice records match the customer_id" do
        SalesEngine::Invoice.find_by_customer_id(100).should be_nil
      end
    end

    context "when there are no invoices in the datastore" do
      it "returns nothing" do
        se.clear_all_data
        SalesEngine::Invoice.find_by_customer_id(customer_1.id).should be_nil
      end
    end
  end

  describe ".find_by_merchant_id" do
    before(:each) do
      invoice_1.merchant_id = merchant_1.id        
      invoice_2.merchant_id = merchant_2.id
    end

    
    context "when invoices exist in the datastore" do
      it "returns the correct invoice record that matches the merchant_id" do
        SalesEngine::Invoice.find_by_merchant_id(merchant_2.id).should == invoice_2
      end

      it "returns nothing if no invoice records match the merchant_id" do
        SalesEngine::Invoice.find_by_merchant_id(100).should be_nil
      end
    end

    context "when there are no invoices in the datastore" do
      it "returns nothing" do
        se.clear_all_data
        SalesEngine::Invoice.find_by_merchant_id(merchant_1.id).should be_nil
      end
    end
  end

  # WASN'T SURE WHAT THE NON-SHIPPED STATUS WOULD BE, SO MAYBE ADD TEST FOR THAT?

  describe ".find_by_status" do
    before(:each) do
      invoice_1.status = "shipped"
      invoice_2.status = "not shipped"
    end
    
    context "when invoices exist in the datastore" do
      it "returns the correct invoice record that matches the status" do
        SalesEngine::Invoice.find_by_status(invoice_1.status).should == invoice_1
      end

      it "returns nothing if no invoice records match the status" do
        SalesEngine::Invoice.find_by_status("random").should be_nil
      end
    end

    context "when there are no invoices in the datastore" do
      it "returns nothing" do
        se.clear_all_data
        SalesEngine::Invoice.find_by_status(invoice_1.status).should be_nil
      end
    end
  end

  describe ".find_by_created_at" do
    context "when invoices exist in the datastore" do
      before(:each) do
        invoice_1.created_at = "03/01/2012 12:00"
        invoice_2.created_at = "01/11/2012 13:00"
      end

      it "returns the correct invoice record that matches the created_at time" do
        SalesEngine::Invoice.find_by_created_at("01/11/2012 13:00").should == invoice_2
      end

      it "returns nothing if no invoice records match the created_at time" do
        SalesEngine::Invoice.find_by_created_at("01/11/1979 10:00").should be_nil
      end
    end

    context "when there are no invoices in the datastore" do
      it "returns nothing" do
        se.clear_all_data
        SalesEngine::Invoice.find_by_created_at("01/11/2012 13:00").should be_nil
      end
    end
  end
  
  describe ".find_by_updated_at" do
      context "when invoices exist in the datastore" do
      before(:each) do
        invoice_1.updated_at = "03/01/2012 12:00"
        invoice_2.updated_at = "01/11/2012 13:00"
      end

      it "returns the correct invoice record that matches the updated_at time" do
        SalesEngine::Invoice.find_by_updated_at("01/11/2012 13:00").should == invoice_2
      end

      it "returns nothing if no invoice records match the updated_at time" do
        SalesEngine::Invoice.find_by_updated_at("01/11/1979 10:00").should be_nil
      end
    end

    context "when there are no invoices in the datastore" do
      it "returns nothing" do
        se.clear_all_data
        SalesEngine::Invoice.find_by_updated_at("01/11/2012 13:00").should be_nil
      end
    end
  end

  describe ".find_all_by_id" do
    context "when invoices exist in the datastore" do
      it "returns the correct invoice records that matches the id" do
        SalesEngine::Invoice.find_all_by_id(invoice_2.id).should == [invoice_2]
      end

      it "returns nothing if no invoice records match the id" do
        SalesEngine::Invoice.find_all_by_id(100).should == []
      end
    end

    context "when there are no invoices in the datastore" do
      it "returns nothing" do
        se.clear_all_data
        SalesEngine::Invoice.find_all_by_id(invoice_1.id).should == []
      end
    end
  end

  describe ".find_all_by_customer_id" do
    context "when invoices exist in the datastore" do
      before(:each) do
        invoice_1.customer_id = customer_1.id
        invoice_2.customer_id = customer_2.id
        invoice_3.customer_id = customer_1.id
      end

      it "returns the correct invoice records that matches the customer_id" do
        SalesEngine::Invoice.find_all_by_customer_id(customer_1.id).should == [invoice_1, invoice_3]
      end

      it "returns nothing if no invoice records match the customer_id" do
        SalesEngine::Invoice.find_all_by_customer_id(100).should == []
      end
    end

    context "when there are no invoices in the datastore" do
      it "returns nothing" do
        se.clear_all_data
        SalesEngine::Invoice.find_all_by_customer_id(customer_1.id).should == []
      end
    end
  end

  describe ".find_all_by_merchant_id" do
    context "when invoices exist in the datastore" do
      before(:each) do
        invoice_1.merchant_id = merchant_1.id
        invoice_2.merchant_id = merchant_2.id
        invoice_3.merchant_id = merchant_1.id
      end

      it "returns the correct invoice records that matches the merchant_id" do
        SalesEngine::Invoice.find_all_by_merchant_id(merchant_1.id).should == [invoice_1, invoice_3]
      end

      it "returns nothing if no invoice records match the merchant_id" do
        SalesEngine::Invoice.find_all_by_merchant_id(100).should == []
      end
    end

    context "when there are no invoices in the datastore" do
      it "returns nothing" do
        se.clear_all_data
        SalesEngine::Invoice.find_all_by_merchant_id(merchant_1.id).should == []
      end
    end
  end

  describe ".find_all_by_status" do    
    context "when invoices exist in the datastore" do
      before(:each) do
        invoice_1.status = "shipped"
        invoice_2.status = "nothing"
        invoice_3.status = "shipped"
      end

      it "returns the correct invoice records that match the status" do
        SalesEngine::Invoice.find_all_by_status("shipped").should == [invoice_1, invoice_3]
      end

      it "returns nothing if no invoice records match the status" do
        SalesEngine::Invoice.find_all_by_status("no comment").should == []
      end
    end

    context "when there are no invoices in the datastore" do
      it "returns nothing" do
        se.clear_all_data
        SalesEngine::Invoice.find_all_by_status("shipped").should == []
      end
    end
  end

  describe ".find_all_by_created_at" do
    context "when invoices exist in the datastore" do
      before(:each) do
        invoice_1.created_at = "03/01/2012 12:00"
        invoice_2.created_at = "01/11/2012 13:00"
        invoice_3.created_at = "01/11/2012 13:00"
      end

      it "returns the correct invoice records that matches the created_at time" do
        SalesEngine::Invoice.find_all_by_created_at("01/11/2012 13:00").should == [invoice_2, invoice_3]
      end

      it "returns nothing if no invoice records match the created_at time" do
        SalesEngine::Invoice.find_all_by_created_at("01/11/1979 10:00").should == []
      end
    end

    context "when there are no invoices in the datastore" do
      it "returns nothing" do
        se.clear_all_data
        SalesEngine::Invoice.find_all_by_created_at("01/11/2012 13:00").should == []
      end
    end
  end

  describe ".find_all_by_updated_at" do
      context "when invoices exist in the datastore" do
      before(:each) do
        invoice_1.updated_at = "03/01/2012 12:00"
        invoice_2.updated_at = "01/11/2012 13:00"
        invoice_3.updated_at = "01/11/2012 13:00"
      end

      it "returns the correct invoice records that matches the updated_at time" do
        SalesEngine::Invoice.find_all_by_updated_at("01/11/2012 13:00").should == [invoice_2, invoice_3]
      end

      it "returns nothing if no invoice records match the updated_at time" do
        SalesEngine::Invoice.find_all_by_updated_at("01/11/1979 10:00").should == []
      end
    end

    context "when there are no invoices in the datastore" do
      it "returns nothing" do
        se.clear_all_data
        SalesEngine::Invoice.find_all_by_updated_at("01/11/2012 13:00").should == []
      end
    end
  end

  describe "#transactions" do
    context "where there are transactions in the database" do
      it "returns all transactions associated with a given invoice id" do
        invoice_1.transactions.should == [transaction_1, transaction_3]
      end

      it "returns nothing if no invoices have the id" do
        invoice_3.transactions.should == []
      end
    end

    context "where there are no transactions in the database" do
      it "returns nothing" do
        se.clear_all_data
        invoice_1.transactions.should == []
      end
    end
  end

  describe "#invoice_items" do
    context "where there are invoice items in the database" do
      it "returns all invoice items associated with a given invoice id" do
        invoice_1.invoice_items.should == [invoice_item_1, invoice_item_3, invoice_item_4]
      end

      it "returns nothing if no invoices have the id" do
        invoice_3.invoice_items.should == []
      end
    end
    context "where there are no invoice items in the database" do
      it "returns nothing" do
        se.clear_all_data
        invoice_1.transactions.should == []
      end
    end

    describe "#items" do
      context "where there are invoice items & items in the database" do
        it "returns a collection of associated Items by way of InvoiceItem objects" do
          invoice_1.items.should == [item_1, item_3, item_4]
        end

        it "returns nothing if no invoice_items have a matching invoice id" do
          invoice_3.items.should == []
        end
      end

      context "where there are no invoice items & items in the database" do
        it "returns nothing" do
          se.clear_all_data
          invoice_1.items.should == []
        end
      end
    end

    describe "#customer" do
      context "where there are customers in the database" do
        before(:each) do
          invoice_1.customer_id = customer_2.id
          invoice_2.customer_id = customer_1.id
        end

        it "returns an instance of Customer associated with this object" do
          invoice_1.customer.should == customer_2
        end
      end
    end
  end

  describe ".create" do
    it "create new invoices" do
      invoice = SalesEngine::Invoice.create(:customer_id => customer_2, :merchant_id => merchant_3, 
        :status => "shipped", :items => [item_1, item_2, item_3], :transaction => transaction_4)
      invoice.customer.should == customer_2
      invoice.merchant.should == merchant_3
      invoice.status.should == "shipped"
      invoice.items.should == [item_1, item_2, item_3]
      invoice.transactions.should == [transaction_4]
    end
  end

  describe "#charge" do
    let(:invoice_4) { Fabricate(:invoice) } 

    it "creates a transaction based on the attributes passed in" do
      invoice_4.charge(:credit_card_number => "4444333322221111",
        :credit_card_expiration_date => "10/13", :result => "success")
      invoice_4.transactions.last.credit_card_number.should == "4444333322221111"
      invoice_4.transactions.last.credit_card_expiration_date.should == "10/13"
      invoice_4.transactions.last.result.should == "success"
    end
  end
end