require 'spec_helper'

describe SalesEngine::Transaction do
  let(:se) { SalesEngine::Database.instance}
  let(:invoice_1) { Fabricate(:invoice) }
  let(:invoice_2) { Fabricate(:invoice) }
  let(:transaction_1) { Fabricate(:transaction, :invoice_id => invoice_1.id) }
  let(:transaction_2) { Fabricate(:transaction, :invoice_id => invoice_2.id) }

  before(:each) do
    se.clear_all_data
    se.add_to_list(invoice_1)
    se.add_to_list(invoice_2)
    se.add_to_list(transaction_1)
    se.add_to_list(transaction_2)
  end
  
  describe "#invoice" do
    it "returns an instance of Invoice associated with this object" do
      transaction_2.invoice.should == invoice_2
    end
  end

  describe ".find_by_invoice_id" do
    it "returns the transaction associated with the invoice id" do
      SalesEngine::Transaction.find_by_invoice_id(invoice_2.id).should == transaction_2
    end
  end

  describe ".find_by_id" do
    it "returns the transaction associated with the id" do
      SalesEngine::Transaction.find_by_id(transaction_2.id).should == transaction_2
    end
  end

  describe ".find_by_credit_card_number" do
    before(:each) do
      transaction_2.credit_card_number = 4634664005836219
    end

    it "returns the transaction associated with the credit card number" do
      SalesEngine::Transaction.find_by_credit_card_number(4634664005836219).should == transaction_2
    end
  end

  describe ".credit_card_expiration_date" do
    before(:each) do
      transaction_2.credit_card_expiration_date = "2012-02-26"
    end

    it "returns the transaction associated with the credit card expiration date" do
      SalesEngine::Transaction.find_by_credit_card_expiration_date("2012-02-26").should == transaction_2
    end
  end
end