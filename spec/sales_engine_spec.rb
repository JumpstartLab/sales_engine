require 'csv'
require 'sales_engine'
require 'customer'
require 'transaction'
require 'merchant'
require 'item'
require 'invoice'
require 'invoice_item'

test_sales_engine = SalesEngine::SalesEngine.new
describe SalesEngine::SalesEngine do
  
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
    it "creates a key => array pair for each data type" do
      classes.each do |klass|
        SalesEngine::Database.instance.send(klass).count.should_not == 0
      end
    end
  end
end

