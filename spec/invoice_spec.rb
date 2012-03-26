require './spec/spec_helper'

describe SalesEngine::Invoice do
  describe ".get_invoices" do
    before(:all) { SalesEngine::Invoice.get_invoices }
    it "stores records from invoices.csv" do
      SalesEngine::Invoice.records.map(&:class).uniq.should == [SalesEngine::Invoice]
    end

    {id: 1, customer_id: 1,
    merchant_id: 92, status: "shipped"}.each do |attribute, value|
      it "records #{attribute}" do
        SalesEngine::Invoice.records.first.send(attribute).should == value
      end
    end
    it "stores the raw CSV for each Invoice" do
      SalesEngine::Invoice.records.first.raw_csv.should be_an Array
    end

    it "stores headers on the Invoice class" do
      SalesEngine::Invoice.csv_headers.should be_an Array
    end
  end

    context "instance methods" do
      let(:invoice) { SalesEngine::Invoice.find_by_id(1) }
    # let(:invoice) { Fabricate(:invoice) }
    describe "#transactions" do
      it "returns transactions" do
        invoice.transactions.should_not be_empty
        invoice.transactions.first.should be_a(SalesEngine::Transaction)
      end
      it "returns all transactions with the invoice of the instance" do
        invoice.transactions.size.should == 1
      end
    end
    describe "#invoice_items" do
      it "returns invoice_items" do
        invoice.invoice_items.should_not be_empty
        invoice.invoice_items.first.should be_a(SalesEngine::InvoiceItem)
      end
      it "returns all invoice_items with the invoice of the instance" do
        invoice.invoice_items.size.should == 4
      end
    end
    describe "#items" do
      it "returns items" do
        invoice.items.should_not be_empty
        invoice.items.first.should be_a(SalesEngine::Item)
      end
      it "returns all items with the invoice of the instance" do
        invoice.items.size.should == 4
      end

      it "does not return duplicates of the same item" do
        SalesEngine::Invoice.find_by_id(2).items.size.should == 1
      end
    end
    describe "#customer" do
      it "returns a customer" do
        invoice.customer.should be_a(SalesEngine::Customer)
      end
      it "returns its customer" do
        invoice.customer.should == SalesEngine::Customer.find_by_id(1)
      end
    end

    describe "#total_paid" do
      it "returns the total dollar amount paid for the invoice" do
        invoice.total_paid.should == BigDecimal("13060.97")
      end

      # it "returns 0 if the transaction status is not 'success'" do
      #   pending
      # end
    end
  end

  context "creating new invoices and related objects" do
    before(:each) do
      @beginning_invoice_count = SalesEngine::Invoice.records.size
      @beginning_transaction_count = SalesEngine::Transaction.records.size
      @beginning_invoice_items_count = SalesEngine::InvoiceItem.records.size
      @new_invoice = SalesEngine::Invoice.create(customer_id: SalesEngine::Customer.find_by_id(1), merchant_id: SalesEngine::Merchant.find_by_id(1), status: "shipped", items: [SalesEngine::Item.find_by_id(1), SalesEngine::Item.find_by_id(2), SalesEngine::Item.find_by_id(3)])
    end
    describe ".create" do
      it "creates and stores a new invoice" do
        ending_count = SalesEngine::Invoice.records.size
        (ending_count - @beginning_invoice_count).should == 1
        SalesEngine::Invoice.records.last.should be_a(SalesEngine::Invoice)
      end
      it "creates a new transaction" do
        ending_count = SalesEngine::Transaction.records.size
        (ending_count - @beginning_transaction_count).should == 1
        SalesEngine::Transaction.records.last.should be_a(SalesEngine::Transaction)
      end
      it "creates new invoice items" do
        ending_count = SalesEngine::InvoiceItem.records.size
        (ending_count - @beginning_invoice_items_count).should == 3
        SalesEngine::InvoiceItem.records.last.should be_a(SalesEngine::InvoiceItem)
      end
    end
    context "charging an invoice" do
      describe "#charge" do
        it "changes the invoice's transaction properly" do
          @new_invoice.charge(:credit_card_number => "4444333322221111", :credit_card_expiration => "10/13", :result => "success")
          SalesEngine::Transaction.find_by_invoice_id(@new_invoice.id).credit_card_number.should == "4444333322221111"
          SalesEngine::Transaction.find_by_invoice_id(@new_invoice.id).credit_card_expiration_date.should == "10/13"
          SalesEngine::Transaction.find_by_invoice_id(@new_invoice.id).result.should == "success"
        end
        it "does not add another transaction record" do
          ending_count = SalesEngine::Transaction.records.size
          (ending_count - @beginning_transaction_count).should == 1
        end
      end
    end
    after(:each) do
      SalesEngine::Invoice.records.pop
      3.times do
        SalesEngine::InvoiceItem.records.pop
      end
      SalesEngine::Transaction.records.pop
    end
  end
end

#id,customer_id,merchant_id,status,created_at,updated_at
#1,1,92,shipped,2012-02-14 20:56:56 UTC,2012-02-26 20:56:56 UTC