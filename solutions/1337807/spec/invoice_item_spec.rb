require 'spec_helper'

describe SalesEngine::InvoiceItem do
  let(:valid_invoice_item) { Fabricate(:invoice_item) }

  it "can be created" do
    valid_invoice_item.should_not be_nil
  end

  it "has an item_id" do
    valid_invoice_item.item_id.should be_an Integer
  end

  it "has an invoice_id" do
    valid_invoice_item.invoice_id.should be_an Integer
  end

  it "has a quantity" do
    valid_invoice_item.quantity.should_not be_nil
  end

  it "creates an invoice item given a numeric quantity as a string" do
    SalesEngine::InvoiceItem.new(
      :id => 1,
      :item_id => 1,
      :invoice_id => 1,
      :quantity => '5',
      :unit_price => 1.75
    )
  end

  it "raises an error given a float quantity" do
    expect do
      SalesEngine::InvoiceItem.new(
        :id => 1,
        :item_id => 1,
        :invoice_id => 1,
        :quantity => 1.5,
        :unit_price => 1.75
      )
    end.to raise_error ArgumentError
  end

  it "has a unit_price" do
    valid_invoice_item.unit_price.should_not be_nil
  end
end
