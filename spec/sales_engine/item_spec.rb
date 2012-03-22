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
  
end