require './spec/spec_helper'

describe SalesEngine::Invoice do
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
  
  it "can be created" do
    valid_invoice.should_not be_nil
  end

  it "has a customer" do
    valid_invoice.customer.should_not be_nil
  end

  it "has a merchant" do
    valid_invoice.merchant.should_not be_nil
  end

  it "has a status" do
    valid_invoice.status.should_not be_nil
  end
end
