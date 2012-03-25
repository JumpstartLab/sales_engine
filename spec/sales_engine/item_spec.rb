require './spec/spec_helper.rb'

describe SalesEngine::Item do

  describe "find_by_" do
    attributes = [:id, :name, :description, :unit_price, :merchant_id, 
                  :created_at, :updated_at]
    attributes.each do |attribute|
      method_name = "find_by_#{attribute}".to_sym

      it "responds to #{method_name}" do
        SalesEngine::Item.should respond_to(method_name)
      end
    end
  end

  describe "find_all_by_" do
    attributes = [:id, :name, :description, :unit_price, :merchant_id, 
                  :created_at, :updated_at]
    attributes.each do |attribute|
      method_name = "find_all_by_#{attribute}".to_sym

      it "responds to #{method_name}" do
        SalesEngine::Item.should respond_to(method_name)
      end
    end
  end

  describe ".random" do
    it "responds to the method" do
      SalesEngine::Item.should respond_to("random".to_sym)
    end
  end

  describe "#invoice_items" do
    let(:item) { SalesEngine::Item.random }
    it "responds to the method" do
      item.should respond_to("invoice_items".to_sym)
    end

    it "returns invoice_items with the same item_id as the example" do
      invoice_items = item.invoice_items
      invoice_items.collect do |ii|
        ii.item_id.should == item.id
      end
    end
  end

  describe "#merchant" do
    let(:item) { SalesEngine::Item.random }
    it "responds to the method" do
      item.should respond_to("merchant".to_sym)
    end

    it "returns an instance of merchant with the same merchant_id as the example" do
      item.merchant.id.should == item.merchant_id
    end
  end

  describe ".most_revenue(num_of_items)" do
    it "should respond to the method" do
      SalesEngine::Item.should respond_to("most_revenue".to_sym)
    end
  end
  
end