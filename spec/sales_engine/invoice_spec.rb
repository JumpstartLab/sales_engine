require 'spec_helper.rb'

describe SalesEngine::Invoice do

  describe "find_by_" do
    attributes = [:id, :customer_id, :merchant_id, :status, 
                    :created_at, :updated_at]
    attributes.each do |attribute|
      method_name = "find_by_#{attribute}".to_sym

      it "responds to #{method_name}" do
        SalesEngine::Invoice.should respond_to(method_name)
      end
    end
  end

  describe "find_all_by_" do
    attributes = [:id, :customer_id, :merchant_id, :status, 
                    :created_at, :updated_at]
    attributes.each do |attribute|
      method_name = "find_all_by_#{attribute}".to_sym

      it "responds to #{method_name}" do
        SalesEngine::Invoice.should respond_to(method_name)
      end
    end
  end

  describe "#transactions" do
    it "returns a collection of associated transaction instances"
  end

  describe "#invoice_items" do
    it "returns a collection of associated invoice_item objects"
  end

  describe "#items" do
    it "returns a collection of associated items by way of invoice_item objects"
  end

  describe "#customer" do
    it "returns an instance of customer associated with this object"
  end

  describe "#charge" do
    it "will call new instance of transaction"
  end  

end