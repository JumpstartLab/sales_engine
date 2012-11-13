require "spec_helper"
require "sales_engine"

describe SalesEngine do
  
    let(:test_customer) {SalesEngine::Customer.random}
    let(:test_merchant) {SalesEngine::Merchant.random}
    let(:test_invoice) {SalesEngine::Invoice.random}
    let(:test_item) {SalesEngine::Item.random}
    let(:test_transaction) {SalesEngine::Transaction.random}
    let(:test_invoice_item) {SalesEngine::InvoiceItem.random}
    
  describe "#initialize" do
    let(:classes) do
      [:customer, :item, :invoice_item, :merchant, :transaction, :invoice]
    end
  end
end

