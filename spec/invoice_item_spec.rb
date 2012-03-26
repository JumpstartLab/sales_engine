require './spec/spec_helper'

describe SalesEngine::InvoiceItem do
  let(:valid_invoice_item) { Fabricate(:invoice_item) }
  let(:valid_item) { Fabricate(:item) }
  let(:valid_invoice) { Fabricate(:invoice) }

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
