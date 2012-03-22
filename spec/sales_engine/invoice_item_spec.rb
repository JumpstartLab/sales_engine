require 'spec_helper.rb'

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

  describe "#invoice" do
    it "returns an instace of Invoice" do
      test_invoice_item.invoice.should be_is_a(SalesEngine::Invoice)
    end
  end

  describe "#item" do
    it "returns an instace of Item" do
      test_invoice_item.item.should be_is_a(SalesEngine::Item)
    end
  end
end