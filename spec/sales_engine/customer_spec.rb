require 'spec_helper.rb'

describe SalesEngine::Customer do

    let(:test_customer) {SalesEngine::Customer.random}
    let(:test_merchant) {SalesEngine::Merchant.random}
    let(:test_invoice) {SalesEngine::Invoice.random}
    let(:test_item) {SalesEngine::Item.random}
    let(:test_transaction) {SalesEngine::Transaction.random}
    let(:test_invoice_item) {SalesEngine::InvoiceItem.random}

  describe '.random' do
    it "returns a Customer object" do
      a = SalesEngine::Customer.random
      a.should be_is_a(SalesEngine::Customer)
    end
  end


  describe 'find_by_#{attribute}(attribute) methods' do
    SalesEngine::Customer::ATTRIBUTES.each do |attribute|
      context ".find_by_#{attribute}" do
        it "should have generated the class method" do
          SalesEngine::Customer.should be_respond_to("find_by_#{attribute}")
        end
      end
    end

    it "returns a customer for find by with correct id" do
      customer = SalesEngine::Customer.find_by_id(test_customer.id.to_i)
      hash = SalesEngine::Database.instance.customer
      customer.should === test_customer
    end

    it "returns an array of customers" do
      puts SalesEngine::Customer.find_all_by_first_name("John")
    end
  end

  describe 'test accessors' do
    SalesEngine::Customer::ATTRIBUTES.each do |attribute|
      context "responds to attr_accessors" do
        it "generates the reader" do
          test_customer.should be_respond_to("#{attribute}")
        end
        it "generates the writer" do
          test_customer.should be_respond_to("#{attribute}=")
        end
      end
    end
  end

  context "#invoices" do
    it "returns an array of Invoices" do
      invoices = test_customer.invoices
      invoices.each do |invoice|
        invoice.should be_is_a(SalesEngine::Invoice)
      end
    end
  end

  context "#transactions" do
    it "returns an array" do
      transactions = test_customer.transactions
      transactions.should be_is_a(Array)
    end

    it "returns an array of Transactions" do
      transactions = test_customer.transactions
      transactions.each do |invoice|
        invoice.should be_is_a(SalesEngine::Transaction)
      end
    end
  end

  context "#favorite_merchant" do
    it "returns a Merchant object" do
      fav_merchant = test_customer.favorite_merchant
      fav_merchant.should be_is_a(SalesEngine::Merchant)
    end
  end

end