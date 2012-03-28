module SalesEngine
  class InvoiceItemRecordTest 
    extend InvoiceItemRecord
  end

  describe InvoiceItemRecord do
    describe "#invoice_items_by_merchant" do
      context "invoice items for merchant exist" do
        it "returns a array of invoice items" do
          rows = InvoiceItemRecordTest.for_merchant(1)
          rows.length.should == 215 
        end
      end

      context "invoice items for merchant doesn't exists" do
        it "returns an empty array" do
          rows = InvoiceItemRecordTest.for_merchant(1000)
          rows.length.should == 0 
        end
      end
    end

    describe "#for_merchant_and_date" do
      context "invoice items for merchant for that date exist" do
        it "returns a array of invoice items" do
          rows = InvoiceItemRecordTest.for_merchant_and_date(1, Date.parse("2012-02-19"))
          rows.length.should == 16 
        end
      end

      context "invoice items for merchant for that date don't exist" do
        it "returns an empty array" do
          rows = InvoiceItemRecordTest.for_merchant_and_date(1, Date.parse("2013-02-19"))
          rows.length.should == 0 
        end
      end
    end

    describe "#invoice_items" do
      it "returns all invoice items" do
        InvoiceItemRecordTest.invoice_items.length.should == 22264
      end
    end


  describe "#insert_invoice_item" do
    let (:invoice_item_hash) { { :item_id => 1, :invoice_id => 2, 
      :quantity => 2, :unit_price => 3 } } 

      before(:all) do
        @old_invoice_items = InvoiceItemRecordTest.invoice_items
        @id = InvoiceItemRecordTest.insert(invoice_item_hash)
        @new_invoice_items = InvoiceItemRecordTest.invoice_items
      end

      it "executes insert query" do
        clean_date = Database.get_dates[1]
        sql = "insert into invoice_items values (?, ?, ?, ?, ?, ?, ?, ?, ?)"
        Database.instance.db.should_receive(:execute).with(sql, nil,
         invoice_item_hash[:item_id], invoice_item_hash[:invoice_id],
         invoice_item_hash[:quantity], invoice_item_hash[:unit_price], 
         DateTime.now.to_s,DateTime.now.to_s, clean_date, clean_date)    
        InvoiceItemRecordTest.insert(invoice_item_hash)
      end


      it "adds a new invoice item to the database" do
        @new_invoice_items.length.should == @old_invoice_items.length + 1
      end

      it "increments invoice_item id" do
        @id.should == 22265
      end
    end 
  end
end