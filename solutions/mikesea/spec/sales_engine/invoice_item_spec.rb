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
      inv_item = SalesEngine::InvoiceItem.find_by_id(56)
      inv_item.id.should == 56
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
      a = SalesEngine::InvoiceItem.find_all_by_invoice_id(15)
      a.size.should_not == 0
    end
  end

   describe "#date" do 
    let (:invoice_item) {SalesEngine::InvoiceItem.find_by_id(24)}
    it "truncates the date created" do 
      date = invoice_item.date 
      date.should == "2012-03-27"
    end 
  end 

  describe "#inv_success" do
    let (:invoice_item) { SalesEngine::InvoiceItem.random }
    it "checks to see if an invoice is successful" do 
      inv_s = invoice_item.inv_success 
      inv_s.nil?.should_not == true
    end 
  end  

  describe ".create(invoice_id, item)" do 
    # let (:invoice_item) 
    # it "creates new invoice items" do
    #   inv_item = invoice_item.new 
    #   inv_item.class.should == SalesEngine::InvoiceItem.class
    # end
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