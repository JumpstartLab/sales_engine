require "spec_helper"
require "sales_engine/invoice_record"

module SalesEngine
  class InvoiceRecordTest 
    extend InvoiceRecord
  end

  describe "#invoices" do
    it "returns all invoices" do
      InvoiceRecordTest.invoices.length.should == 4985
    end
  end

  describe "#successful_for_merchant" do
    context "invoices for merchant exist" do
      it "returns a array of invoices" do
        rows = InvoiceRecordTest.for_merchant(1)
        rows.length.should == 51 
      end
    end

    context "invoices for merchant doesn't exists" do
      it "returns an empty array" do
        rows = InvoiceRecordTest.for_merchant(1000)
        rows.length.should == 0 
      end
    end
  end

  describe "#successful_merchant_and_date" do
    context "invoices for merchant for that date exist" do
      it "returns a array of invoices" do
        rows = InvoiceRecordTest.for_merchant_and_date(1, Date.parse("2012-02-19"))
        rows.length.should == 4
      end
    end

    context "invoices for merchant for that date don't exist" do
      it "returns an empty array" do
        rows = InvoiceRecordTest.for_merchant_and_date(1, Date.parse("2013-02-19"))
        rows.length.should == 0
      end
    end
  end

  describe "#for_item" do
    context "invoice items for item exist" do
      it "returns a array of invoices" do
        rows = InvoiceItem.for_item(1)
        rows.length.should == 10
      end
    end

    context "invoice items for item don't exist" do
      it "returns an empty array" do
        rows = InvoiceItem.for_item(10000)
        rows.length.should == 0
      end
    end
  end

  describe "#insert_invoice" do
    let (:invoice_hash) { { :customer_id => 1, :merchant_id => 2, 
                  :status => "shipped" } } 
    
    before(:all) do
      @old_invoices = InvoiceRecordTest.invoices
      @id = InvoiceRecordTest.insert(invoice_hash)
      @new_invoices = InvoiceRecordTest.invoices
    end

    it "database execute insert query" do
      clean_date = SalesEngine::Database.get_dates[1]
      sql = "insert into invoices values (?, ?, ?, ?, ?, ?, ?, ?)"
      Database.instance.db.should_receive(:execute).with(sql, nil,
                               invoice_hash[:customer_id], invoice_hash[:merchant_id],
                               invoice_hash[:status], DateTime.now.to_s,
                               DateTime.now.to_s, clean_date, clean_date)
      InvoiceRecordTest.insert(invoice_hash)
    end

    it "adds a new invoice to the database" do
      @new_invoices.length.should == @old_invoices.length + 1
    end

    it "increments invoice id" do
      @id.should == 4986
    end
  end
end
