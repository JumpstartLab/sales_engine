require 'spec_helper.rb'

describe SalesEngine::InvoiceItem do
  
  describe "find_by_" do
    attributes = [:id, :item_id, :invoice_id, :quantity, 
                  :unit_price, :created_at, :updated_at]
    attributes.each do |attribute|
      method_name = "find_by_#{attribute}".to_sym

      it "responds to #{method_name}" do
        SalesEngine::InvoiceItem.should respond_to(method_name)
      end
    end

    it "returns an InvoiceItem" do
      a = SalesEngine::InvoiceItem.find_by_id("1")
      a.class.should == SalesEngine::InvoiceItem
    end
  end

  describe "find_all_by_" do
    attributes = [:id, :item_id, :invoice_id, :quantity, 
                  :unit_price, :created_at, :updated_at]
    attributes.each do |attribute|
      method_name = "find_all_by_#{attribute}".to_sym

      it "responds to #{method_name}" do
        SalesEngine::InvoiceItem.should respond_to(method_name)
      end
    end

    it "returns a collection of InvoiceItems" do
      a = SalesEngine::InvoiceItem.find_all_by_id("1")
      a[0].class.should == SalesEngine::InvoiceItem
    end
  end

  describe "#invoice" do
    let(:invoice_item) { SalesEngine::InvoiceItem.random }
    it "responds to the method" do
      invoice_item.should respond_to("invoice".to_sym)
    end

    it "returns an Invoice associated with the invoice_item" do
      invoice_item.invoice.id.should == invoice_item.invoice_id
    end
  end

  describe "#item" do
    let(:invoice_item) { SalesEngine::InvoiceItem.random }
    it "responds to the method" do
      invoice_item.should respond_to("item".to_sym)
    end

    it "returns an Item associated with the invoice_item" do
      invoice_item.item.id.should == invoice_item.item_id
    end
  end

end