require './spec/spec_helper'

describe SalesEngine::Transaction do
  let(:valid_customer) { 
    SalesEngine::Customer.new(
      :id => 1,
      :first_name => 'Jackie',
      :last_name => 'Chan'
    )
  }

  let(:valid_merchant) { SalesEngine::Merchant.new(:id => 1, :name => "Test Merchant") }

  let(:valid_invoice) { 
    SalesEngine::Invoice.new(
      :id => 1,
      :customer => valid_customer,
      :merchant => valid_merchant,
      :status => 'shipped'
    )
  }

  let(:valid_transaction) {
    SalesEngine::Transaction.new(
      :id => 1,
      :invoice => valid_invoice,
      :credit_card_number => 4068631943231473,
      :credit_card_expiration => Date.today + 1,
      :result => 'success'
    )
  }

  it "can be created" do
    valid_transaction.should_not be_nil
  end

  it "has an invoice" do
    valid_transaction.invoice.should be_an SalesEngine::Invoice
  end

  it "has a credit card number" do
    valid_transaction.credit_card_number.should_not be_nil
  end

  it "raises an ArgumentError when given a string credit card number"

  it "has a credit card expiration date" do
    valid_transaction.credit_card_expiration.should be_a Date
  end

  it "has a result" do
    valid_transaction.result.should_not be_nil
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
