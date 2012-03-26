require 'spec_helper'

describe SalesEngine::InvoiceItem do

  let(:test_invoice_item){Fabricate(:invoice_item)}

  describe "#item" do
    context "returns an item associated with this invoice item" do
      it "returns an item" do
        test_invoice_item.item.is_a?(SalesEngine::Item).should == true
      end

      it "returns an item associated with this invoice item" do
        test_invoice_item.item.id.should == test_invoice_item.item_id
      end
    end
  end

  describe "#invoice" do
    context "returns an invoice associated with this invoice_item" do

      it "returns an invoice" do
        test_invoice_item.invoice.is_a?(SalesEngine::Invoice).should == true
      end

      it "returns an invoice associated with this invoice item" do
        test_invoice_item.invoice.id.should == test_invoice_item.invoice_id
      end
    end
  end
end

