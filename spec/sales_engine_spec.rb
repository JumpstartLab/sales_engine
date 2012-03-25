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
    # it "successfully starts up (more of a time test than hoping it works)" do
    #   SalesEngine.startup
    # end
    it "creates a key => array pair for each data type" do
      classes.each do |klass|
        SalesEngine::Database.instance.send(klass).count.should_not == 0
      end
    end

  end
end

