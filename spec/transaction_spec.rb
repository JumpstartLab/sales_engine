require 'spec_helper.rb'
require "transaction.rb"

test_sales_engine = SalesEngine::SalesEngine.new
describe SalesEngine::Transaction do
  
    let(:test_customer) {SalesEngine::Customer.random}
    let(:test_merchant) {SalesEngine::Merchant.random}
    let(:test_invoice) {SalesEngine::Invoice.random}
    let(:test_item) {SalesEngine::Item.random}
    let(:test_transaction) {SalesEngine::Transaction.random}
    let(:test_invoice_item) {SalesEngine::InvoiceItem.random}

  describe 'find_by_#{attribute}(attribute) methods' do
    SalesEngine::Transaction::ATTRIBUTES.each do |attribute|
      context ".find_by_#{attribute}" do
        it "should have generated the class method" do
          SalesEngine::Transaction.should be_respond_to("find_by_#{attribute}")
        end
      end
    end
  end

  describe 'test accessors' do
    SalesEngine::Transaction::ATTRIBUTES.each do |attribute|
      context "responds to attr_accessors" do
        it "generates the reader" do
          test_transaction.should be_respond_to("#{attribute}")
        end
        it "generates the writer" do
          test_transaction.should be_respond_to("#{attribute}=")
        end
      end
    end
  end
end