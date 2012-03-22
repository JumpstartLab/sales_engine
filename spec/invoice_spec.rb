require 'spec_helper.rb'
require "merchant"
require "customer"
require "transaction"
require "invoice"
require "item"
require "invoice_item"
require "rspec"
require "date"
require 'ap'

describe SalesEngine::Invoice do
  describe 'find_by_#{attribute}(attribute) methods' do
    Invoice::ATTRIBUTES.each do |attribute|
      context ".find_by_#{attribute}" do
        it "should have generated the class method" do
          Invoice.should be_respond_to("find_by_#{attribute}")
        end
      end

      context ".find_all_by#{attribute}" do
        it "generates the class method" do
          Invoice.should be_respond_to("find_all_by_#{attribute}")
        end

        it "returns an array" do
          invoices = Invoice.send("find_all_by_#{attribute}", 1234)
          invoices.should be_is_a(Array)
        end
      end
    end
  end

  describe 'test accessors' do
    let(:test_invoice) { Invoice.new }
    Invoice::ATTRIBUTES.each do |attribute|
      context "responds to attr_accessors" do
        it "generates the reader" do
          test_invoice.should be_respond_to("#{attribute}")
        end
        it "generates the writer" do
          test_invoice.should be_respond_to("#{attribute}=")
        end
      end
    end
  end

  describe "test instance methods" do
    let(:test_invoice) { Invoice.new(id: "1",customer_id: "1",merchant_id: 
      "92",status: "shipped",created_at: "2012-02-14 20:56:56 UTC",
      updated_at: "2012-02-26 20:56:56 UTC") }

    context "#transactions returns a collection of associated Transaction instances" do
      it "returns an array of transactions" do
        transactions = test_invoice.transactions
        transactions.each do |transaction|
          transaction.should be_is_a(Transaction)
        end
      end

      context "#invoice_items returns a collection of associated InvoiceItem instances" do
        it "returns an array of InvoiceItem objects" do
          invoice_items = test_invoice.invoice_items
          invoice_items.each do |invoice_item|
            invoice_item.should be_is_a(InvoiceItem)
          end
        end
      end
    end
  end
end