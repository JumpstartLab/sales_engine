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
  end

end