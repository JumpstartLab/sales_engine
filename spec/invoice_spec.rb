require './spec/spec_helper'

describe Invoice do
  let(:se) { Database.instance}
  let(:invoice_1) { Invoice.new({ :id => 1 }) }
  let(:invoice_2) { Invoice.new({ :id => 2 }) }

  before(:each) do
    se.clear_all_data
    se.add_to_list(invoice_1)
    se.add_to_list(invoice_2)
  end

  describe ".random" do
    let(:invoice_3) { Invoice.new({ :id => 3 }) }

    context "when invoice exist in the datastore" do
      it "returns a random invoice record" do
        se.invoices.include?(Invoice.random).should be_true
      end
    end

    context "when there are no invoices in the datastore" do
      it "returns nil" do
        se.clear_all_data
        Invoice.random.should be_nil
      end
    end
  end

  describe ".find_by_id" do
    context "when invoices exist in the datastore" do
      it "returns the correct invoice record that matches the id" do
        Invoice.find_by_id(2).should == invoice_2
      end

      it "returns nothing if no invoice records match the id" do
        Invoice.find_by_id(100).should be_nil
      end
    end

    context "when there are no invoices in the datastore" do
      it "returns nothing" do
        se.clear_all_data
        Invoice.find_by_id(1).should be_nil
      end
    end
  end

  describe ".find_by_customer_id" do
    let(:invoice_1) { Invoice.new({ :customer_id => 1 }) }
    let(:invoice_2) { Invoice.new({ :customer_id => 2 }) }
    
    context "when invoices exist in the datastore" do
      it "returns the correct invoice record that matches the customer_id" do
        Invoice.find_by_customer_id(2).should == invoice_2
      end

      it "returns nothing if no invoice records match the customer_id" do
        Invoice.find_by_customer_id(100).should be_nil
      end
    end

    context "when there are no invoices in the datastore" do
      it "returns nothing" do
        se.clear_all_data
        Invoice.find_by_customer_id(1).should be_nil
      end
    end
  end

  describe ".find_by_merchant_id" do
    let(:invoice_1) { Invoice.new({ :merchant_id => 1 }) }
    let(:invoice_2) { Invoice.new({ :merchant_id => 2 }) }
    
    context "when invoices exist in the datastore" do
      it "returns the correct invoice record that matches the merchant_id" do
        Invoice.find_by_merchant_id(2).should == invoice_2
      end

      it "returns nothing if no invoice records match the merchant_id" do
        Invoice.find_by_merchant_id(100).should be_nil
      end
    end

    context "when there are no invoices in the datastore" do
      it "returns nothing" do
        se.clear_all_data
        Invoice.find_by_merchant_id(1).should be_nil
      end
    end
  end

  # WASN'T SURE WHAT THE NON-SHIPPED STATUS WOULD BE, SO MAYBE ADD TEST FOR THAT?

  describe ".find_by_status" do
    let(:invoice_1) { Invoice.new({ :status => "shipped" }) }
    let(:invoice_2) { Invoice.new({ :status => "not shipped" }) }
    
    context "when invoices exist in the datastore" do
      it "returns the correct invoice record that matches the status" do
        Invoice.find_by_status("shipped").should == invoice_1
      end

      it "returns nothing if no invoice records match the status" do
        Invoice.find_by_status("random").should be_nil
      end
    end

    context "when there are no invoices in the datastore" do
      it "returns nothing" do
        se.clear_all_data
        Invoice.find_by_status(1).should be_nil
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
        Invoice.find_by_created_at("01/11/2012 13:00").should == invoice_2
      end

      it "returns nothing if no invoice records match the created_at time" do
        Invoice.find_by_created_at("01/11/1979 10:00").should be_nil
      end
    end

    context "when there are no invoices in the datastore" do
      it "returns nothing" do
        se.clear_all_data
        Invoice.find_by_created_at("01/11/2012 13:00").should be_nil
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
        Invoice.find_by_updated_at("01/11/2012 13:00").should == invoice_2
      end

      it "returns nothing if no invoice records match the updated_at time" do
        Invoice.find_by_updated_at("01/11/1979 10:00").should be_nil
      end
    end

    context "when there are no invoices in the datastore" do
      it "returns nothing" do
        se.clear_all_data
        Invoice.find_by_updated_at("01/11/2012 13:00").should be_nil
      end
    end
  end

  describe ".find_all_by_id" do
    context "when invoices exist in the datastore" do
      it "returns the correct invoice records that matches the id" do
        Invoice.find_all_by_id(2).should == [invoice_2]
      end

      it "returns nothing if no invoice records match the id" do
        Invoice.find_all_by_id(100).should == []
      end
    end

    context "when there are no invoices in the datastore" do
      it "returns nothing" do
        se.clear_all_data
        Invoice.find_all_by_id(1).should == []
      end
    end
  end

  describe ".find_all_by_customer_id" do
    context "when invoices exist in the datastore" do
      let(:invoice_3) { Invoice.new({ :id => 3 }) }

      before(:each) do
        invoice_1.customer_id = 1
        invoice_2.customer_id = 2
        invoice_3.customer_id = 1
        se.add_to_list(invoice_3)
      end

      it "returns the correct invoice records that matches the customer_id" do
        Invoice.find_all_by_customer_id(1).should == [invoice_1, invoice_3]
      end

      it "returns nothing if no invoice records match the customer_id" do
        Invoice.find_all_by_customer_id(100).should == []
      end
    end

    context "when there are no invoices in the datastore" do
      it "returns nothing" do
        se.clear_all_data
        Invoice.find_all_by_customer_id(1).should == []
      end
    end
  end

  describe ".find_all_by_merchant_id" do
    context "when invoices exist in the datastore" do
      let(:invoice_3) { Invoice.new({ :id => 3 }) }

      before(:each) do
        invoice_1.merchant_id = 1
        invoice_2.merchant_id = 2
        invoice_3.merchant_id = 1
        se.add_to_list(invoice_3)
      end

      it "returns the correct invoice records that matches the merchant_id" do
        Invoice.find_all_by_merchant_id(1).should == [invoice_1, invoice_3]
      end

      it "returns nothing if no invoice records match the merchant_id" do
        Invoice.find_all_by_merchant_id(100).should == []
      end
    end

    context "when there are no invoices in the datastore" do
      it "returns nothing" do
        se.clear_all_data
        Invoice.find_all_by_merchant_id(1).should == []
      end
    end
  end

  describe ".find_all_by_status" do    
    context "when invoices exist in the datastore" do
      let(:invoice_3) { Invoice.new({ :id => 3}) }

      before(:each) do
        invoice_1.status = "shipped"
        invoice_2.status = "nothing"
        invoice_3.status = "shipped"
        se.add_to_list(invoice_3)
      end

      it "returns the correct invoice records that match the status" do
        Invoice.find_all_by_status("shipped").should == [invoice_1, invoice_3]
      end

      it "returns nothing if no invoice records match the status" do
        Invoice.find_all_by_status("no comment").should == []
      end
    end

    context "when there are no invoices in the datastore" do
      it "returns nothing" do
        se.clear_all_data
        Invoice.find_all_by_status(1).should == []
      end
    end
  end

  describe ".find_all_by_created_at" do
    context "when invoices exist in the datastore" do
      let(:invoice_3) { Invoice.new({ :id => 3 }) }

      before(:each) do
        invoice_1.created_at = "03/01/2012 12:00"
        invoice_2.created_at = "01/11/2012 13:00"
        invoice_3.created_at = "01/11/2012 13:00"
        se.add_to_list(invoice_3)
      end

      it "returns the correct invoice records that matches the created_at time" do
        Invoice.find_all_by_created_at("01/11/2012 13:00").should == [invoice_2, invoice_3]
      end

      it "returns nothing if no invoice records match the created_at time" do
        Invoice.find_all_by_created_at("01/11/1979 10:00").should == []
      end
    end

    context "when there are no invoices in the datastore" do
      it "returns nothing" do
        se.clear_all_data
        Invoice.find_all_by_created_at("01/11/2012 13:00").should == []
      end
    end
  end

  describe ".find_all_by_updated_at" do
      context "when invoices exist in the datastore" do
      let(:invoice_3) { Invoice.new({ :id => 3 }) }
      before(:each) do
        invoice_1.updated_at = "03/01/2012 12:00"
        invoice_2.updated_at = "01/11/2012 13:00"
        invoice_3.updated_at = "01/11/2012 13:00"
        se.add_to_list(invoice_3)
      end

      it "returns the correct invoice records that matches the updated_at time" do
        Invoice.find_all_by_updated_at("01/11/2012 13:00").should == [invoice_2, invoice_3]
      end

      it "returns nothing if no invoice records match the updated_at time" do
        Invoice.find_all_by_updated_at("01/11/1979 10:00").should == []
      end
    end

    context "when there are no invoices in the datastore" do
      it "returns nothing" do
        se.clear_all_data
        Invoice.find_all_by_updated_at("01/11/2012 13:00").should == []
      end
    end
  end

  describe "#transactions" do
    context "where there are transactions in the database" do
      let(:transaction_1) { Transaction.new({:id => 1, :invoice_id => invoice_1.id }) }
      let(:transaction_2) { Transaction.new({:id => 2, :invoice_id => invoice_2.id }) }
      let(:transaction_3) { Transaction.new({:id => 3, :invoice_id => invoice_1.id }) }
      let(:invoice_3) { Invoice.new({ :id => 3 }) }

      before(:each) do
        se.add_to_list(transaction_1)
        se.add_to_list(transaction_2)
        se.add_to_list(transaction_3)
        se.add_to_list(invoice_3)
      end

      it "returns all transactions associated with a given invoice id" do
        invoice_1.transactions.should == [transaction_1, transaction_3]
      end

      it "returns nothing if no invoices have the id" do
        invoice_3.transactions.should == []
      end
    end

    context "where there are no transactions in the database" do
      it "returns nothing" do
        invoice_1.transactions.should == []
      end
    end
  end

  describe "#invoice_items" do
    context "where there are invoice items in the database" do
      let(:invoice_item_1) { InvoiceItem.new({:id => 1, :invoice_id => invoice_1.id }) }
      let(:invoice_item_2) { InvoiceItem.new({:id => 2, :invoice_id => invoice_2.id }) }
      let(:invoice_item_3) { InvoiceItem.new({:id => 3, :invoice_id => invoice_1.id }) }
      let(:invoice_3) { Invoice.new({ :id => 3 }) }

      before(:each) do
        se.add_to_list(invoice_item_1)
        se.add_to_list(invoice_item_2)
        se.add_to_list(invoice_item_3)
        se.add_to_list(invoice_3)
      end

      it "returns all invoice items associated with a given invoice id" do
        invoice_1.invoice_items.should == [invoice_item_1, invoice_item_3]
      end

      it "returns nothing if no invoices have the id" do
        invoice_3.invoice_items.should == []
      end
    end
    context "where there are no invoice items in the database" do
      it "returns nothing" do
        invoice_1.transactions.should == []
      end
    end
    describe "#items" do
      context "where there are invoice items & items in the database" do
        let(:item_1) { Item.new({ :id => 1 }) }
        let(:item_2) { Item.new({ :id => 2 }) }
        let(:item_3) { Item.new({ :id => 3 }) }
        let(:item_4) { Item.new({ :id => 4 }) }        
        let(:invoice_item_1) { InvoiceItem.new({:id => 1, :invoice_id => invoice_1.id, :item_id => item_1.id}) }
        let(:invoice_item_2) { InvoiceItem.new({:id => 2, :invoice_id => invoice_2.id, :item_id => item_2.id}) }
        let(:invoice_item_3) { InvoiceItem.new({:id => 3, :invoice_id => invoice_1.id, :item_id => item_3.id}) }
        let(:invoice_item_4) { InvoiceItem.new({:id => 4, :invoice_id => invoice_1.id, :item_id => item_4.id}) }
        let(:invoice_3) { Invoice.new({ :id => 3 }) }

        before(:each) do
          se.add_to_list(item_1)
          se.add_to_list(item_2)
          se.add_to_list(item_3)
          se.add_to_list(item_4)
          se.add_to_list(invoice_item_1)
          se.add_to_list(invoice_item_2)
          se.add_to_list(invoice_item_3)
          se.add_to_list(invoice_item_4)
          se.add_to_list(invoice_3)
        end

        it "returns a collection of associated Items by way of InvoiceItem objects" do
          invoice_1.items.should == [item_1, item_3, item_4]
        end

        it "returns nothing if no invoice_items have a matching invoice id" do
          invoice_3.items.should == []
        end
      end

      context "where there are no invoice items & items in the database" do
        it "returns nothing" do
          invoice_1.items.should == []
        end
      end
    end
  end
end