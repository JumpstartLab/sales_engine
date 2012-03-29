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

      it "returns an item" do
        result = SalesEngine::Item.find_by_id(2)
        result.class.should == SalesEngine::Item
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

  describe "#charged_invoice_items" do 
    let (:item) { SalesEngine::Item.random }
    it "returns an instance of InvoiceItems associated with Item" do 
      ii = item.charged_invoice_items
      ii.size.should_not == 0
    end 
  end 

  describe "#revenue" do 
    let (:item) { SalesEngine::Item.random }
    it "calculates revenue across all items" do
      rev = item.revenue 
      rev.should_not == nil 
    end
  end 

  # describe "#quantity_sold" do 
  #   let(:item) { SalesEngine::Item.random } 
  #   it "calculates the quantity sold of a particular item" do 
  #     iq = item.quantity_sold
  #     iq.class.should == integer
  #   end 
  # end 

  describe "#merchant" do
    let(:item) { SalesEngine::Item.random }
    it "responds to the method" do
      item.should respond_to("merchant".to_sym)
    end

    it "returns an instance of merchant with the same merchant_id as the example" do
      item.merchant.id.should == item.merchant_id
    end
  end

  describe ".most_revenue(num_items)" do
    it "should respond to the method" do
      SalesEngine::Item.should respond_to("most_revenue".to_sym)
    end
  end

  describe "#best_day" do 
    let (:item) { SalesEngine::Item.random}
    it "returns the date with the most sales for a given item" do 
      day = item.best_day 
      day.class.should == Date
    end 
  end 
  
  describe ".most_items(num_items)" do
    let (:item) { SalesEngine::Item.random }
    it "returns the top x item instances ranked by items sold" do 
      num_items = 3
      result = SalesEngine::Item.most_items(num_items)
      result.size.should == num_items
    end 
  end
end