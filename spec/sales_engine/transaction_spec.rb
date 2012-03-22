require 'spec_helper.rb'

describe SalesEngine::Transaction do
  
  describe "find_by_" do
    attributes = [:id, :invoice_id, :credit_card_number,
                  :credit_card_expiration_date, :result,
                  :created_at, :updated_at]
    attributes.each do |attribute|
      method_name = "find_by_#{attribute}".to_sym

      it "responds to #{method_name}" do
        SalesEngine::Transaction.should respond_to(method_name)
      end
    end
  end

  describe "find_all_by_" do
    attributes = [:id, :invoice_id, :credit_card_number,
                  :credit_card_expiration_date, :result,
                  :created_at, :updated_at]
    attributes.each do |attribute|
      method_name = "find_all_by_#{attribute}".to_sym

      it "responds to #{method_name}" do
        SalesEngine::Transaction.should respond_to(method_name)
      end
    end
  end

end