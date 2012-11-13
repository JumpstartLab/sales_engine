require 'spec_helper'

describe SalesEngine::Transaction do
  let(:se) { SalesEngine::Database.instance}
  let(:invoice_1) { Fabricate(:invoice) }
  let(:invoice_2) { Fabricate(:invoice) }
  let(:transaction_1) { Fabricate(:transaction, :invoice_id => invoice_1.id) }
  let(:transaction_2) { Fabricate(:transaction, :invoice_id => invoice_2.id) }
  let(:transaction_3) { Fabricate(:transaction, :invoice_id => invoice_1.id) }

  before(:each) do
    se.clear_all_data
    se.add_to_list(invoice_1)
    se.add_to_list(invoice_2)
    se.add_to_list(transaction_1)
    se.add_to_list(transaction_2)
    se.add_to_list(transaction_3)
  end
  
  describe "#invoice" do
    it "returns an instance of Invoice associated with this object" do
      transaction_2.invoice.should == invoice_2
    end
  end

  describe ".random" do
    context "when transactions exist in the datastore" do
      it "returns a random transaction record" do
        se.transactions.include?(SalesEngine::Transaction.random).should be_true
      end
    end

    context "when there are no transactions in the datastore" do
      it "returns nil" do
        se.clear_all_data
        SalesEngine::Transaction.random.should be_nil
      end
    end
  end

  describe ".find_by_invoice_id" do
    context "when there are transactions in the datastore" do
      it "returns the transaction associated with the invoice id" do
        SalesEngine::Transaction.find_by_invoice_id(invoice_2.id).should == transaction_2
      end

      it "returns nothing if no transactions match the invoice id" do
        SalesEngine::Transaction.find_by_invoice_id(100).should be_nil
      end
    end

    context "when there are no transactions in the datastore" do
      it "returns nothing" do
        se.clear_all_data
        SalesEngine::Transaction.find_by_invoice_id(invoice_2.id).should be_nil
      end
    end
  end

  describe ".find_by_id" do
    context "when transactions exist in the datastore" do
      it "returns the transaction associated with the id" do
        SalesEngine::Transaction.find_by_id(transaction_2.id).should == transaction_2
      end
    end

      it "returns nothing if no transaction records match the id" do
        SalesEngine::Transaction.find_by_id(100).should be_nil
      end

    context "when there are no transactions in the datastore" do
      it "returns nothing" do
        se.clear_all_data
        SalesEngine::Transaction.find_by_id(transaction_2.id).should be_nil
      end
    end
  end

  describe ".find_by_credit_card_number" do
    context "when there are transactions in the datastore" do
      before(:each) do
        transaction_2.credit_card_number = 4634664005836219
      end

      it "returns the transaction associated with the credit card number" do
        SalesEngine::Transaction.find_by_credit_card_number(transaction_2.credit_card_number).should == transaction_2
      end

      it "returns nothing if no transaction records match the credit card number" do
        SalesEngine::Transaction.find_by_credit_card_number(0000111122223333).should be_nil
      end
    end

    context "when there are no transactions in the datastore" do
      it "returns nothing" do
        se.clear_all_data
        SalesEngine::Transaction.find_by_credit_card_number(transaction_2.credit_card_number).should be_nil
      end
    end
  end

  # NEED TO UPDATE DATE PARSING
  describe ".find_by_credit_card_expiration_date" do
    before(:each) do
      transaction_2.credit_card_expiration_date = "2012-02-26"
    end

    context "when there are transactions in the datastore" do
      it "returns the transaction associated with the credit card expiration date" do
        SalesEngine::Transaction.find_by_credit_card_expiration_date(transaction_2.credit_card_expiration_date).should == transaction_2
      end

      it "returns nothing if no transaction records match the credit card expiration date" do
        SalesEngine::Transaction.find_by_credit_card_expiration_date("2413-02-26").should be_nil
      end
    end

    context "when there are no transactions in the datastore" do
      it "returns nothing" do
        se.clear_all_data
        SalesEngine::Transaction.find_by_credit_card_expiration_date(transaction_2.credit_card_expiration_date).should be_nil
      end
    end
  end

  describe ".find_by_result" do
    before(:each) do
      transaction_1.result = "success"
      transaction_2.result = "failure"
    end
    
    context "when transactions exist in the datastore" do
      it "returns the correct transaction record that matches the status" do
        SalesEngine::Transaction.find_by_result(transaction_1.result).should == transaction_1
      end

      it "returns nothing if no invoice records match the status" do
        SalesEngine::Transaction.find_by_result("random").should be_nil
      end
    end

    context "when there are no invoices in the datastore" do
      it "returns nothing" do
        se.clear_all_data
        SalesEngine::Transaction.find_by_result(transaction_1.result).should be_nil
      end
    end
  end

  describe ".find_all_by_id" do
    context "when transactions exist in the datastore" do
      it "returns the correct transaction records that match the id" do
        SalesEngine::Transaction.find_all_by_id(transaction_2.id).should == [transaction_2]
      end

      it "returns nothing if no transaction records match the id" do
        SalesEngine::Transaction.find_all_by_id(100).should == []
      end
    end

    context "when there are no transactions in the datastore" do
      it "returns nothing" do
        se.clear_all_data
        SalesEngine::Transaction.find_all_by_id(transaction_1.id).should == []
      end
    end
  end

  describe ".find_all_by_invoice_id" do
    context "when transactions exist in the datastore" do
      it "returns the correction transaction records that match the id" do
        SalesEngine::Transaction.find_all_by_invoice_id(invoice_1.id) == [transaction_1, transaction_3]
      end

      it "returns nothing if no transaction records match the id" do
        SalesEngine::Transaction.find_all_by_invoice_id(100).should == []
      end
    end

    context "when no transactions exist in the datastore" do
      it "returns nothing" do
        se.clear_all_data
        SalesEngine::Transaction.find_all_by_invoice_id(invoice_1.id).should == []
      end
    end
  end

  describe ".find_all_by_credit_card_number" do
    before(:each) do
      transaction_1.credit_card_number = 4634664005836219
      transaction_3.credit_card_number = 4634664005836219
    end

    context "when transactions exist in the datastore" do
      it "returns the correct transaction records that match the credit card number" do
        SalesEngine::Transaction.find_all_by_credit_card_number(4634664005836219).should == [transaction_1, transaction_3]
      end

      it "returns nothing if no transaction records match the credit card number" do
        SalesEngine::Transaction.find_all_by_credit_card_number(0000111122223333).should == []
      end
    end

    context "when there are no transactions in the datastore" do
      it "returns nothing" do
        se.clear_all_data
        SalesEngine::Transaction.find_all_by_credit_card_number(transaction_1.credit_card_number).should == []
      end
    end
  end

  describe ".find_all_by_credit_card_expiration_date" do
    before(:each) do
      transaction_1.credit_card_expiration_date = "2012-02-26"
      transaction_3.credit_card_expiration_date = "2012-02-26"
    end

    context "when transactions exist in the datastore" do
      it "returns the correct transaction records that match the credit card expiration date" do
        SalesEngine::Transaction.find_all_by_credit_card_expiration_date("2012-02-26").should == [transaction_1, transaction_3]
      end

      it "returns nothing if no transaction records match the credit card expiration date" do
        SalesEngine::Transaction.find_all_by_credit_card_expiration_date("2022-02-26").should == []
      end
    end

    context "when there are no transactions in the datastore" do
      it "returns nothing" do
        se.clear_all_data
        SalesEngine::Transaction.find_all_by_credit_card_expiration_date("2012-02-26").should == []
      end
    end
  end

  describe ".find_all_by_result" do
    before(:each) do
      transaction_1.result = "success"
      transaction_2.result = "failure"
      transaction_3.result = "success"
    end

    context "when transactions exist in the datastore" do
      it "returns the correct transaction records that match the result" do
        SalesEngine::Transaction.find_all_by_result("success").should == [transaction_1, transaction_3]
      end

      it "returns nothing if nothing if no transaction records match the result" do
        SalesEngine::Transaction.find_all_by_result("dummy").should == []
      end
    end

    context "when there are no transactions in the datastore" do
      it "returns nothing" do
        se.clear_all_data
        SalesEngine::Transaction.find_all_by_result("success").should == []
      end
    end
  end
end