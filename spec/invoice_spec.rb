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
      # it "stores the raw CSV for each Invoice" do
      #   SalesEngine::Invoice.records.first.raw_csv.should be_an Array
      # end

      # it "stores headers on the Invoice class" do
      #   SalesEngine::Invoice.csv_headers.should be_an Array
      # end
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
      context "for successful transactions" do
        it "returns the total dollar amount paid for the invoice" do
          invoice.total_paid.should == BigDecimal("13060.97")
        end
      end
      context "for unsuccessful transactions" do
        it "returns 0" do
          invoice.stub(:successful_transaction => false)
          invoice.total_paid.should == 0
        end
      end
    end
    describe "#num_items" do
      context "for successful transactions" do
        it "returns the total items for the invoice" do
          invoice.num_items.should == BigDecimal("22")
        end
      end
      context "for unsuccessful transactions" do
        it "returns 0" do
          invoice.stub(:successful_transaction => false)
          invoice.num_items.should == 0
        end
      end
    end
    describe "#successful_transaction" do
      context "when the transaction has a status of 'success'" do
        it "returns true" do
          good_transaction = double("transaction")
          good_transaction.stub(:result => "success")
          invoice.stub(:transactions => [good_transaction])
          invoice.send(:successful_transaction).should be_true
        end
      end
      context "when the transaction has a status of 'pending'" do
        it "returns false" do
          bad_transaction = double("transaction")
          bad_transaction.stub(:result => "pending")
          invoice.stub(:transactions => [bad_transaction])
          invoice.send(:successful_transaction).should be_false
        end
      end
    end

  end

  context "creating new invoices and related objects" do
    before(:each) do
      @beginning_invoice_count = SalesEngine::Invoice.records.size
      @beginning_transaction_count = SalesEngine::Transaction.records.size
      @beginning_invoice_items_count = SalesEngine::InvoiceItem.records.size
      @new_invoice = SalesEngine::Invoice.create(customer: SalesEngine::Customer.find_by_id(1), merchant: SalesEngine::Merchant.find_by_id(1), status: "shipped", items: [SalesEngine::Item.find_by_id(1), SalesEngine::Item.find_by_id(2), SalesEngine::Item.find_by_id(3)])
    end
    describe ".create" do
      it "creates and stores a new invoice" do
        ending_count = SalesEngine::Invoice.records.size
        (ending_count - @beginning_invoice_count).should == 1
        SalesEngine::Invoice.records.last.should be_a(SalesEngine::Invoice)
      end
      it "creates new invoice items" do
        ending_count = SalesEngine::InvoiceItem.records.size
        (ending_count - @beginning_invoice_items_count).should == 3
        SalesEngine::InvoiceItem.records.last.should be_a(SalesEngine::InvoiceItem)
      end
    end
    context "charging an invoice" do
      describe "#charge" do
        before(:each) do
          @new_invoice.charge(:credit_card_number => "4444333322221111", :credit_card_expiration_date => "10/13", :result => "success")
        end
        it "changes the invoice's transaction properly" do
          SalesEngine::Transaction.find_by_invoice_id(@new_invoice.id).credit_card_number.should == "4444333322221111"
          SalesEngine::Transaction.find_by_invoice_id(@new_invoice.id).credit_card_expiration_date.should == "10/13"
          SalesEngine::Transaction.find_by_invoice_id(@new_invoice.id).result.should == "success"
        end
        it "adds a new transaction record" do
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
  context "extensions" do
    describe ".pending" do
      it "returns an empty array when all transactions are a success" do
        SalesEngine::Invoice.pending.should == []
      end
      it "returns Invoices without a successful transaction" do
        invoice =  SalesEngine::Invoice.find_by_id(1)
        bad_transaction = double("transaction")
        bad_transaction.stub(:result => "pending")
        bad_transaction.stub(:invoice_id => 1)
        invoice.stub(:transactions => [bad_transaction])
        SalesEngine::Transaction.records << bad_transaction
        SalesEngine::Invoice.pending.should == [invoice]
      end
      after(:all) { SalesEngine::Transaction.records.pop }
    end
    describe ".average_revenue" do
      context "when date is not passed" do
        it "returns a 0 big decimal when no processed invoices" do
          mock_invoice = {}
          3.times do | i |
            mock_invoice[i] = double("invoice")
            mock_invoice[i].stub(:total_paid => 0)
          end
          SalesEngine::Invoice.stub(:records => [mock_invoice[0], mock_invoice[1], mock_invoice[2]])
          SalesEngine::Invoice.average_revenue.should == BigDecimal("0")
        end
        it "returns the average of the total for each invoice" do
          mock_invoice = {}
          3.times do | i |
            mock_invoice[i] = double("invoice")
            mock_invoice[i].stub(:successful_transaction => true, :total_paid => (i * 3))
          end
          SalesEngine::Invoice.stub(:records => [mock_invoice[0], mock_invoice[1], mock_invoice[2]])
          SalesEngine::Invoice.average_revenue.should == BigDecimal("3")
        end
      end
      context "when date is not nil" do
        it "returns a 0 BigDecimal when that date has no processed invoices" do
          mock_invoice = {}
          3.times do | i |
            mock_invoice[i] = double("invoice")
            mock_invoice[i].stub(:total_paid => 0, :created_at => DateTime.now)
          end
          SalesEngine::Invoice.stub(:records => [mock_invoice[0], mock_invoice[1], mock_invoice[2]])
          SalesEngine::Invoice.average_revenue(DateTime.now).should == BigDecimal("0")
        end
        it "returns the average of the invoice revenues for that date" do
          mock_invoice = {}
          3.times do | i |
            mock_invoice[i] = double("invoice")
            mock_invoice[i].stub(:successful_transaction => true, :total_paid => (i * 3), :created_at => DateTime.now)
          end
          mock_invoice[0].stub(:created_at => DateTime.parse("Jan 1, 2012"))
          SalesEngine::Invoice.stub(:records => [mock_invoice[0], mock_invoice[1], mock_invoice[2]])
          SalesEngine::Invoice.average_revenue(DateTime.now).should == BigDecimal("4.5")
        end
      end
    end
    describe ".average_items" do
      context "when date is not passed" do
        it "returns a 0 big decimal when no processed invoices" do
          mock_invoice = {}
          3.times do | i |
            mock_invoice[i] = double("invoice")
            mock_invoice[i].stub(:num_items => 0)
          end
          SalesEngine::Invoice.stub(:records => [mock_invoice[0], mock_invoice[1], mock_invoice[2]])
          SalesEngine::Invoice.average_items.should == BigDecimal("0")
        end
        it "returns the average of the number of items for each invoice" do
          mock_invoice = {}
          3.times do | i |
            mock_invoice[i] = double("invoice")
            mock_invoice[i].stub(:successful_transaction => true, :num_items => (i * 3))
          end
          SalesEngine::Invoice.stub(:records => [mock_invoice[0], mock_invoice[1], mock_invoice[2]])
          SalesEngine::Invoice.average_items.should == BigDecimal("3")
        end
      end
      context "when date is not nil" do
        it "returns a 0 BigDecimal when that date has no processed invoices" do
          mock_invoice = {}
          3.times do | i |
            mock_invoice[i] = double("invoice")
            mock_invoice[i].stub(:num_items => 0, :created_at => DateTime.now)
          end
          SalesEngine::Invoice.stub(:records => [mock_invoice[0], mock_invoice[1], mock_invoice[2]])
          SalesEngine::Invoice.average_items(DateTime.now).should == BigDecimal("0")
        end
        it "returns the average of the invoice items for that date" do
          mock_invoice = {}
          3.times do | i |
            mock_invoice[i] = double("invoice")
            mock_invoice[i].stub(:successful_transaction => true, :num_items => (i * 3), :created_at => DateTime.now)
          end
          mock_invoice[0].stub(:created_at => DateTime.parse("Jan 1, 2012"))
          SalesEngine::Invoice.stub(:records => [mock_invoice[0], mock_invoice[1], mock_invoice[2]])
          SalesEngine::Invoice.average_items(DateTime.now).should == BigDecimal("4.5")
        end
      end
    end
  end
end

#id,customer_id,merchant_id,status,created_at,updated_at
#1,1,92,shipped,2012-02-14 20:56:56 UTC,2012-02-26 20:56:56 UTC