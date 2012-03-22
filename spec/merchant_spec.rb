require 'spec_helper.rb'
require "merchant"
require "customer"
require "transaction"
require "invoice"
require "item"
require "invoice_item"
require "rspec"
require "date"

test_sales_engine = SalesEngine::SalesEngine.new
describe SalesEngine::Merchant do
  
    let(:test_customer) {SalesEngine::Customer.random}
    let(:test_merchant) {SalesEngine::Merchant.random}
    let(:test_invoice) {SalesEngine::Invoice.random}
    let(:test_item) {SalesEngine::Item.random}
    let(:test_transaction) {SalesEngine::Transaction.random}
    let(:test_invoice_item) {SalesEngine::InvoiceItem.random}

  describe 'find_by_#{attribute}(attribute) methods' do
    SalesEngine::Merchant::ATTRIBUTES.each do |attribute|
      context ".find_by_#{attribute}" do
        it "should have generated the class method" do
          SalesEngine::Merchant.should be_respond_to("find_by_#{attribute}")
        end
      end
    end
  end

  describe 'test accessors' do
    SalesEngine::Merchant::ATTRIBUTES.each do |attribute|
      context "responds to attr_accessors" do
        it "generates the reader" do
          test_merchant.should be_respond_to("#{attribute}")
        end
        it "generates the writer" do
          test_merchant.should be_respond_to("#{attribute}=")
        end
      end
    end
  end

  context "#items" do
    it "returns an array of items" do
      items = test_merchant.items
      items.should be_is_a(Array)
    end

    it "should return and array of Items" do
      items = test_merchant.items
      items.each do |item|
        item.should be_is_a(SalesEngine::Item)
      end
    end
  end

  context "#invoices" do
    it "returns an array" do
      invoices = test_merchant.invoices
      invoices.should be_is_a(Array)
    end

    it "returns an array of Invoices" do
      invoices = test_merchant.invoices
      invoices.each do |invoice|
        invoice.should be_is_a(SalesEngine::Invoice)
      end
    end
  end

  context "#revenue" do
    it "returns a valid total revenue without argument" do
      revenue = test_merchant.revenue
      revenue.should be_is_a(BigDecimal)
    end

    it "returns a valid number for a given date" do
      revenue = test_merchant.revenue(Date.today)
      revenue.should be_is_a(BigDecimal)
    end
  end

  # context "#favorite_customer" do
  #   it "returns a customer object" do
  #     test_merchant.favorite_customer.should be_is_a(Customer)
  #   end
    
  #   it "returns the customer with highest number of transactions" do
  #     c1 = Customer.new(:transactions => [Transaction.new, Transaction.new])
  #     c2 = Customer.new(:transactions => [Transaction.new])
  #     t1 = 
  #     test_merchant
  #   end
  # end
end



























