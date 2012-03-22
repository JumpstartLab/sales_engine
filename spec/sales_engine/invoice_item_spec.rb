require 'spec_helper'

describe SalesEngine::InvoiceItem do
  test_attr = {:id => "2", :item_id => "2136", :invoice_id => "1", 
    :quantity => "6", :unit_price => "42671",
      :created_at => "2012-02-26 20:56:56 UTC",
    :updated_at => "2012-02-26 20:56:56 UTC"}

  let(:test_invoice_item){SalesEngine::InvoiceItem.new(test_attr)}

  describe "#item" do
    context "returns an item associated with this invoice item" do
      it "returns an item" do
        test_invoice_item.item.is_a?(SalesEngine::Item).should == true
      end

      it "returns an item associated with this invoice item" do
        test_invoice_item.item.id.should == test_invoice_item.item_id
      end
    end
  end
end

