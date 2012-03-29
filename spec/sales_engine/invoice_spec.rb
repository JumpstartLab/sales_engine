require 'spec_helper.rb'

describe SalesEngine::Invoice do

  let(:test_customer) {SalesEngine::Customer.random}
  let(:test_merchant) {SalesEngine::Merchant.random}
  let(:test_invoice) {SalesEngine::Invoice.random}
  let(:test_item) {SalesEngine::Item.random}
  let(:test_transaction) {SalesEngine::Transaction.random}
  let(:test_invoice_item) {SalesEngine::InvoiceItem.random}

  describe 'find_by_#{attribute}(attribute) methods' do
    SalesEngine::Invoice::ATTRIBUTES.each do |attribute|
      context ".find_by_#{attribute}" do
        it "should have generated the class method" do
          SalesEngine::Invoice.should be_respond_to("find_by_#{attribute}")
        end
      end

      context ".find_all_by#{attribute}" do
        it "generates the class method" do
          SalesEngine::Invoice.should be_respond_to("find_all_by_#{attribute}")
        end

        it "returns an array" do
          invoices = SalesEngine::Invoice.send("find_all_by_#{attribute}", 1234)
          invoices.should be_is_a(Array)
        end
      end
    end
  end

  describe 'test accessors' do
    SalesEngine::Invoice::ATTRIBUTES.each do |attribute|
      context "responds to attr_accessors" do
        it "generates the reader" do
          test_invoice.should be_respond_to("#{attribute}")
        end
        it "generates the writer" do
          test_invoice.should be_respond_to("#{attribute}=")
        end
      end
    end
  end

  describe "test instance methods" do

    context "#transactions returns a collection of associated Transaction instances" do
      it "returns an array of transactions" do
        transactions = test_invoice.transactions
        transactions.each do |transaction|
          transaction.should be_is_a(SalesEngine::Transaction)
        end
      end
    end

    context "#invoice_items returns a collection of associated InvoiceItem instances" do
      it "returns an array of InvoiceItem objects" do
        invoice_items = test_invoice.invoice_items
        invoice_items.each do |invoice_item|
          invoice_item.should be_is_a(SalesEngine::InvoiceItem)
        end
      end
    end

    context "#items returns a collection of associated Item instances" do
      it "returns an array of Item objects" do
        items = test_invoice.items
        items.each do |item|
          item.should be_is_a(SalesEngine::Item)
        end
      end
    end

    context "#customer returns an instance of Customer associated with this object" do
      it "returns a Customer" do
        customer = test_invoice.customer
        if customer
          customer.should be_is_a(SalesEngine::Customer)
        end
      end
    end
<<<<<<< HEAD

    describe ".create" do
      let(:customer) { SalesEngine::Customer.random }
      let(:merchant) { SalesEngine::Merchant.random }
      let(:items) do
        (1..3).map { SalesEngine::Item.random }
      end
      it "creates a new invoice and charges to it" do

        invoice = SalesEngine::Invoice.create(customer: customer, merchant: merchant, items: items)

        invoice.charge(credit_card_number: '1111222233334444',  credit_card_expiration_date: "10/14", result: "success")

        invoice.should be_is_a(SalesEngine::Invoice)
      end
    end
=======
  
    context "#revenue(date)" do
      it "returns a valid revenue" do
        rev = test_invoice.revenue(Date.parse("March 17, 2012"))
      end
    end
  end
  context "extensions" do
    describe ".pending" do
      it "returns Invoices without a successful transaction" do
        invoice =  SalesEngine::Invoice.find_by_id(13)
        pending_invoices = SalesEngine::Invoice.pending

        pending_invoices[1].should == invoice
      end
    end

    describe ".average_revenue" do
      it "returns the average of the totals of each invoice" do
        SalesEngine::Invoice.average_revenue.should == BigDecimal("12369.53")
      end
    end

    describe ".average_revenue(date)" do
      it "returns the average of the invoice revenues for that date" do
        SalesEngine::Invoice.average_revenue(Date.parse("March 17, 2012")).should == BigDecimal("11603.14")
      end
    end

    describe ".average_items" do
      it "returns the average of the number of items for each invoice" do
        SalesEngine::Invoice.average_items.should == BigDecimal("24.45")
      end
    end

    describe ".average_items(date)" do
      it "returns the average of the invoice items for that date" do
        SalesEngine::Invoice.average_items(Date.parse("March 21, 2012")).should == BigDecimal("24.29")
      end
    end
  
    it "creates a new invoice" do

      invoice = SalesEngine::Invoice.create(customer: test_customer, merchant: test_merchant, items: [test_item])
      invoice.should be_is_a(SalesEngine::Invoice)

    end
>>>>>>> 2fb9c7b578ae7f287b1f5554366e0c521548f7cb
  end

    context "extensions" do
      describe ".pending" do
        it "returns Invoices without a successful transaction" do
          invoice =  SalesEngine::Invoice.find_by_id(13)
          pending_invoices = SalesEngine::Invoice.pending

          pending_invoices[1].should == invoice
        end
      end

      describe ".average_revenue" do
        it "returns the average of the totals of each invoice" do
          SalesEngine::Invoice.average_revenue.should == BigDecimal("12369.53")
        end
      end

      describe ".average_revenue(date)" do
        it "returns the average of the invoice revenues for that date" do
          SalesEngine::Invoice.average_revenue(DateTime.parse("March 17, 2012")).should == BigDecimal("11603.14")
        end
      end

      describe ".average_items" do
        it "returns the average of the number of items for each invoice" do
          SalesEngine::Invoice.average_items.should == BigDecimal("24.45")
        end
      end

      describe ".average_items(date)" do
        it "returns the average of the invoice items for that date" do
          SalesEngine::Invoice.average_items(DateTime.parse("March 21, 2012")).should == BigDecimal("24.29")
        end
      end
    end
  end
