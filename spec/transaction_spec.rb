require 'spec_helper'

describe SalesEngine::Transaction do
  let(:valid_transaction) { Fabricate(:transaction) }
  let(:valid_invoice) { Fabricate(:invoice) }

  it "can be created" do
    valid_transaction.should_not be_nil
  end

  it "has an invoice" do
    valid_transaction.invoice_id.should be_an Integer
  end

  it "raises an ArgumentError when given a nil invoice" do
    expect do
      SalesEngine::Transaction.new(
        :id => 1,
        :invoice => nil,
        :credit_card_number => 4751151955673308,
        :credit_card_expiration => Date.today + 1,
        :result => 'shipped'
      )
      end.to raise_error ArgumentError
  end

  it "has a credit card number" do
    valid_transaction.credit_card_number.should_not be_nil
  end

  it "raises an ArgumentError when given a string credit card number" do
    expect do
      SalesEngine::Transaction.new(
        :id => 1,
        :invoice => valid_invoice,
        :credit_card_number => "Jackie Chan",
        :credit_card_expiration => Date.today + 1,
        :result => 'shipped'
      )
      end.to raise_error ArgumentError
  end

  it "raises an ArgumentError when given a nil credit card number" do
    expect do
      SalesEngine::Transaction.new(
        :id => 1,
        :invoice => valid_invoice,
        :credit_card_number => nil,
        :credit_card_expiration => Date.today + 1,
        :result => 'shipped'
      )
      end.to raise_error ArgumentError
  end

  it "has a credit card expiration date" do
    valid_transaction.credit_card_expiration.should be_a Date
  end

  it "creates a transaction with a nil expiration date" do
    SalesEngine::Transaction.new(
      :id => 1,
      :invoice_id => 1,
      :credit_card_number => 4751151955673308,
      :credit_card_expiration => nil,
      :result => 'shipped'
    )
  end

  it "has a result" do
    valid_transaction.result.should_not be_nil
  end

  it "has a string result" do
    valid_transaction.result.should be_a String
  end

  it "raises an ArgumentError when given a nil result" do
    expect do
      SalesEngine::Transaction.new(
        :id => 1,
        :invoice => valid_invoice,
        :credit_card_number => 4751151955673308,
        :credit_card_expiration => Date.today + 1,
        :result => nil
      )
      end.to raise_error ArgumentError
  end

  it "raises an ArgumentError when given a blank result" do
    expect do
      SalesEngine::Transaction.new(
        :id => 1,
        :invoice => valid_invoice,
        :credit_card_number => 4068631943231473,
        :credit_card_expiration => Date.today + 1,
        :result => ''
      )
      end.to raise_error ArgumentError
  end
end
