require 'spec_helper.rb'
require "merchant"
require "invoice_item"
require "transaction"
require "invoice"
require "item"
require "invoice_item"
require "rspec"
require "date"

describe SalesEngine::InvoiceItem do
  describe 'test accessors' do
    let(:test_invoice_item) { InvoiceItem.new }
    InvoiceItem::ATTRIBUTES.each do |attribute|
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