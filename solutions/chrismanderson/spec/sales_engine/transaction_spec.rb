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

  test_transactions = [ Fabricate(:transaction,
                                  :id => 1,
                                  :invoice_id => 2,
                                  :credit_card_number => "123",
                                  :credit_card_expiration_date => "3/31",
                                  :result => "success",
                                  :created_at => "3/31",
                                  :updated_at => "3/31"),
                        Fabricate(:transaction,
                                  :id => 2,
                                  :invoice_id => "3",
                                  :credit_card_number => "123",
                                  :credit_card_expiration_date => "3/31",
                                  :result => "success",
                                  :created_at => "3/31",
                                  :updated_at => "3/31"),
                        Fabricate(:transaction,
                                  :id => "2",
                                  :invoice_id => "2",
                                  :credit_card_number => "123",
                                  :credit_card_expiration_date => "3/31",
                                  :result => "success",
                                  :created_at => "3/31",
                                  :updated_at => "3/31")]

  describe ".find_by_id()" do
    it "returns one transaction" do
      SalesEngine::Database.instance.stub(:transactions).and_return(test_transactions)
      transaction = SalesEngine::Transaction.find_by_id("2").should be_a SalesEngine::Transaction
    end

    it "is associated with the id passed in" do
      SalesEngine::Database.instance.stub(:transactions).and_return(test_transactions)
      result = SalesEngine::Transaction.find_by_id("2")
      result.id.should == "2"
    end
  end

  describe ".find_by_invoice_id()" do
    it "returns one transaction" do
      SalesEngine::Database.instance.stub(:transactions).and_return(test_transactions)
      SalesEngine::Transaction.find_by_invoice_id(2).should be_a SalesEngine::Transaction
    end

    it "is associated with the id passed in" do
      SalesEngine::Database.instance.stub(:transactions).and_return(test_transactions)
      result = SalesEngine::Transaction.find_by_invoice_id("2")
      result.invoice_id.should == "2"
    end
  end

  describe ".find_by_credit_card_number()" do
    it "returns one transaction" do
      SalesEngine::Database.instance.stub(:transactions).and_return(test_transactions)
      SalesEngine::Transaction.find_by_credit_card_number("123").should be_a SalesEngine::Transaction
    end

    it "is associated with the credit card number passed in" do
      SalesEngine::Database.instance.stub(:transactions).and_return(test_transactions)
      result = SalesEngine::Transaction.find_by_credit_card_number("123")
      result.credit_card_number.should == "123"
    end
  end

  describe ".find_by_credit_card_expiration_date()" do
    it "returns one transaction" do
      SalesEngine::Database.instance.stub(:transactions).and_return(test_transactions)
      SalesEngine::Transaction.find_by_credit_card_expiration_date("3/31").should be_a SalesEngine::Transaction
    end

    it "is associated with the credit_card_expiration_date passed in" do
      SalesEngine::Database.instance.stub(:transactions).and_return(test_transactions)
      result = SalesEngine::Transaction.find_by_credit_card_expiration_date("3/31")
      result.credit_card_expiration_date.should == "3/31"
    end
  end

  describe ".find_by_created_at()" do
    it "returns one transaction" do
      SalesEngine::Database.instance.stub(:transactions).and_return(test_transactions)
      SalesEngine::Transaction.find_by_created_at("3/31").should be_a SalesEngine::Transaction
    end

    it "is associated with the date passed in" do
      SalesEngine::Database.instance.stub(:transactions).and_return(test_transactions)
      result = SalesEngine::Transaction.find_by_created_at("3/31")
      result.created_at.should == "3/31"
    end
  end

  describe ".find_by_updated_at()" do
    it "returns one transaction" do
      SalesEngine::Database.instance.stub(:transactions).and_return(test_transactions)
      SalesEngine::Transaction.find_by_updated_at("3/31").should be_a SalesEngine::Transaction
    end

    it "is associated with the date passed in" do
      SalesEngine::Database.instance.stub(:transactions).and_return(test_transactions)
      result = SalesEngine::Transaction.find_by_updated_at("3/31")
      result.updated_at.should == "3/31"
    end
  end

  describe ".find_all_by_id()" do
    it "returns an array of transactions" do
      SalesEngine::Database.instance.stub(:transactions).and_return(test_transactions)
      SalesEngine::Transaction.find_all_by_id("2").all?{|i| i.is_a? SalesEngine::Transaction}.should == true
    end

    it "contains transactions related to the invoice_id passed in" do
      SalesEngine::Database.instance.stub(:transactions).and_return(test_transactions)
      results = SalesEngine::Transaction.find_all_by_id("2")
      results.sample.id.should == "2"
    end
  end

  describe ".find_all_by_invoice_id()" do
    it "returns an array of transactions" do
      SalesEngine::Database.instance.stub(:transactions).and_return(test_transactions)
      SalesEngine::Transaction.find_all_by_invoice_id("2").all?{|i| i.is_a? SalesEngine::Transaction}.should == true
    end

    it "contains transactions related to the invoice_id passed in" do
      SalesEngine::Database.instance.stub(:transactions).and_return(test_transactions)
      results = SalesEngine::Transaction.find_all_by_invoice_id("2")
      results.sample.invoice_id.should == "2"
    end
  end

  describe ".find_all_by_credit_card_number()" do
    it "returns an array of transactions" do
      SalesEngine::Database.instance.stub(:transactions).and_return(test_transactions)
      SalesEngine::Transaction.find_all_by_credit_card_number("123").all?{|i| i.is_a? SalesEngine::Transaction}.should == true
    end

    it "contains transactions related to the credit_card_number passed in" do
      SalesEngine::Database.instance.stub(:transactions).and_return(test_transactions)
      results = SalesEngine::Transaction.find_all_by_credit_card_number("123")
      results.sample.credit_card_number.should == "123"
    end
  end

  describe ".find_all_by_credit_card_expiration_date()" do
    it "returns an array of transactions" do
      SalesEngine::Database.instance.stub(:transactions).and_return(test_transactions)
      SalesEngine::Transaction.find_all_by_credit_card_expiration_date("3/31").all?{|i| i.is_a? SalesEngine::Transaction}.should == true
    end

    it "contains transactions related to the credit_card_expiration_date passed in" do
      SalesEngine::Database.instance.stub(:transactions).and_return(test_transactions)
      results = SalesEngine::Transaction.find_all_by_credit_card_expiration_date("3/31")
      results.sample.credit_card_expiration_date.should == "3/31"
    end
  end

  describe ".find_all_by_result()" do
    it "returns an array of transactions" do
      SalesEngine::Database.instance.stub(:transactions).and_return(test_transactions)
      SalesEngine::Transaction.find_all_by_result("success").all?{|i| i.is_a? SalesEngine::Transaction}.should == true
    end

    it "contains transactions related to the result passed in" do
      SalesEngine::Database.instance.stub(:transactions).and_return(test_transactions)
      results = SalesEngine::Transaction.find_all_by_result("success")
      results.sample.result.should == "success"
    end
  end

  describe ".find_all_by_created_at()" do
    it "returns an array of transactions" do
      SalesEngine::Database.instance.stub(:transactions).and_return(test_transactions)
      SalesEngine::Transaction.find_all_by_created_at("3/31").all?{|i| i.is_a? SalesEngine::Transaction}.should == true
    end

    it "contains transactions related to the result passed in" do
      SalesEngine::Database.instance.stub(:transactions).and_return(test_transactions)
      results = SalesEngine::Transaction.find_all_by_created_at("3/31")
      results.sample.created_at.should == "3/31"
    end
  end

  describe ".find_all_by_updated_at()" do
    it "returns an array of transactions" do
      SalesEngine::Database.instance.stub(:transactions).and_return(test_transactions)
      SalesEngine::Transaction.find_all_by_updated_at("3/31").all?{|i| i.is_a? SalesEngine::Transaction}.should == true
    end

    it "contains transactions related to the result passed in" do
      SalesEngine::Database.instance.stub(:transactions).and_return(test_transactions)
      results = SalesEngine::Transaction.find_all_by_updated_at("3/31")
      results.sample.updated_at.should == "3/31"
    end
  end

end
