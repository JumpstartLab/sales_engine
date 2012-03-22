require 'spec_helper.rb'

describe SalesEngine::Item do
 
    let(:test_customer) {SalesEngine::Customer.random}
    let(:test_merchant) {SalesEngine::Merchant.random}
    let(:test_invoice) {SalesEngine::Invoice.random}
    let(:test_item) {SalesEngine::Item.random}
    let(:test_transaction) {SalesEngine::Transaction.random}
    let(:test_invoice_item) {SalesEngine::InvoiceItem.random}

  describe 'test accessors' do
    SalesEngine::Item::ATTRIBUTES.each do |attribute|
      context "responds to attr_accessors" do
        it "generates the reader" do
          test_item.should be_respond_to("#{attribute}")
        end
        it "generates the writer" do
          test_item.should be_respond_to("#{attribute}=")
        end
      end
    end
  end

  describe "#invoice_items" do
    it "returns an array of InvoiceItem objects" do
      test_item.invoice_items.each do |invoice_item|
        invoice_item.should be_is_a(SalesEngine::InvoiceItem)
      end
    end
  end

  describe "#merchant" do
    it "returns an instace of Merchant" do
      test_item.merchant.should be_is_a(SalesEngine::Merchant)
    end
  end
end