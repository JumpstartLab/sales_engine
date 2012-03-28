require 'spec_helper'

describe SalesEngine::Transaction do

  let(:test_transaction) { Fabricate(:transaction) }


  describe "#invoice" do
    context "returns an invoice associated with this transaction" do
      it "returns an invoice" do
        test_transaction.invoice.is_a?(SalesEngine::Invoice).should == true
      end

      it "returns an invoice associated with this transaction" do
        test_transaction.invoice.id.should == test_transaction.invoice_id
      end
    end
  end
  describe ".random" do
    it "returns a transaction" do
      SalesEngine::Transaction.random.should be_a SalesEngine::Transaction
    end
  end

  describe ".find_all_by_invoice_id()" do
    it "returns an array of transactions" do
      SalesEngine::Transaction.find_all_by_invoice_id("2").all?{|i| i.is_a? SalesEngine::Transaction}.should == true
    end
  end

  describe ".find_by_invoice_id()" do
    it "returns one transaction" do
      SalesEngine::Transaction.find_by_invoice_id("2").should be_a SalesEngine::Transaction
    end

    it "is associated with the id passed in" do
      result = SalesEngine::Transaction.find_by_invoice_id("2")
      result.invoice_id.should == "2"
    end
  end

  describe ".find_by_credit_card_number()" do
    it "returns one transaction" do
      SalesEngine::Transaction.find_by_credit_card_number("4177816490204479").should be_a SalesEngine::Transaction
    end

    it "is associated with the credit card number passed in" do
      result = SalesEngine::Transaction.find_by_credit_card_number("4177816490204479")
      result.credit_card_number.should == "4177816490204479"
    end
  end

  describe ".find_by_credit_card_expiration_date()" do
    it "returns one transaction" do
      pending
      # Transactions.csv currently has no ccd expiration information
      SalesEngine::Transaction.find_by_credit_card_expiration_date("2012-02-26 20:56:56 UTC").should be_a SalesEngine::Transaction
    end

    it "is associated with the credit_card_expiration_date passed in" do
      pending
      # Transactions.csv currently has no data for ccd expiration.
      result = SalesEngine::Transaction.find_by_credit_card_expiration_date("2012-02-26 20:56:56 UTC")
      result.credit_card_expiration_date.should == "2012-02-26 20:56:56 UTC"
    end
  end
end


# describe Transaction do
# end
