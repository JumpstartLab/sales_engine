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
  end
end