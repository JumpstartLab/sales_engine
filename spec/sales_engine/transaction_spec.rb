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

    it "returns a Transaction" do
      a = SalesEngine::Transaction.find_by_id("1")
      a.class.should == SalesEngine::Transaction
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

    it "returns a collection of transactions" do
      a = SalesEngine::Transaction.find_all_by_id("1")
      a[0].class.should == SalesEngine::Transaction
    end
  end

  describe "#invoice" do
    let(:transaction) { SalesEngine::Transaction.random }
    it "responds to the method" do
      transaction.should respond_to("invoice".to_sym)
    end

    it "should return an invoice with the same invoice_id as the example" do
      transaction.invoice.id.should == transaction.invoice_id
    end
  end

end