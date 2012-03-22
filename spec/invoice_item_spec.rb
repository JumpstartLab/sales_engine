require 'spec_helper.rb'
require "merchant"
require "invoice_item"
require "transaction"
require "invoice"
require "item"
require "invoice_item"
require "rspec"
require "date"

test_sales_engine = SalesEngine::SalesEngine.new
describe SalesEngine::InvoiceItem do
 
    let(:test_customer) {SalesEngine::Customer.random}
    let(:test_merchant) {SalesEngine::Merchant.random}
    let(:test_invoice) {SalesEngine::Invoice.random}
    let(:test_item) {SalesEngine::Item.random}
    let(:test_transaction) {SalesEngine::Transaction.random}
    let(:test_invoice_item) {SalesEngine::InvoiceItem.random}

  describe 'test accessors' do
    SalesEngine::InvoiceItem::ATTRIBUTES.each do |attribute|
      context "responds to attr_accessors" do
        it "generates the reader" do
          test_invoice_item.should be_respond_to("#{attribute}")
        end
        it "generates the writer" do
          test_invoice_item.should be_respond_to("#{attribute}=")
        end
      end
    end
  end
end