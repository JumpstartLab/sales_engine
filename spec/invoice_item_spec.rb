require './spec/spec_helper'

describe SalesEngine::InvoiceItem do
  let(:valid_merchant) { SalesEngine::Merchant.new(:id => 1, :name => "Test Merchant") }

  let(:valid_customer) { 
    SalesEngine::Customer.new(
      :id => 1,
      :first_name => 'Jackie',
      :last_name => 'Chan'
    )
  }

  let(:valid_item) do
    SalesEngine::Item.new(
      :id => 1, 
      :name => "Item 1", 
      :description => "Description",
      :unit_price => 12,
      :merchant => valid_merchant
    )
  end

  let(:valid_invoice) { 
    SalesEngine::Invoice.new(
      :id => 1,
      :customer => valid_customer,
      :merchant => valid_merchant,
      :status => 'shipped'
    )
  }

  let(:valid_invoice_item) {
    SalesEngine::InvoiceItem.new(
      :id => 1,
      :item => valid_item,
      :invoice => valid_invoice,
      :quantity => 1,
      :unit_price => 1.75
    )
  }

  it "can be created" do
    valid_invoice_item.should_not be_nil
  end

  it "has an item" do
    valid_invoice_item.item.should be_an SalesEngine::Item
  end

  it "has an invoice" do
    valid_invoice_item.invoice.should be_an SalesEngine::Invoice
  end

  it "has a quantity" do
    valid_invoice_item.quantity.should_not be_nil
  end

  it "raises an error given a string quantity" do
    expect do
      SalesEngine::InvoiceItem.new(
        :id => 1,
        :item => valid_item,
        :invoice => valid_invoice,
        :quantity => 'puppy',
        :unit_price => 1.75
      )
    end.to raise_error ArgumentError
  end

  it "raises an error given a float quantity" do
    expect do
      SalesEngine::InvoiceItem.new(
        :id => 1,
        :item => valid_item,
        :invoice => valid_invoice,
        :quantity => 1.5,
        :unit_price => 1.75
      )
    end.to raise_error ArgumentError
  end

  it "has a unit_price" do
    valid_invoice_item.unit_price.should_not be_nil
  end

  it "raises an error given a string unit_price" do
    expect do
      SalesEngine::InvoiceItem.new(
        :id => 1,
        :item => valid_item,
        :invoice => valid_invoice,
        :quantity => 1,
        :unit_price => 'puppy'
      )
    end.to raise_error ArgumentError
  end
end
