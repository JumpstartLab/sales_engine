require 'spec_helper'

describe SalesEngine::Item do
  
  test_attr = {:id => "100", :name => "Item Name",
    :description => "This is an item description",
    :unit_price => "293048",
    :merchant_id =>"50",
    :created_at => "2012-02-26 20:56:56 UTC",
    :updated_at => "2012-02-26 20:56:56 UTC"}

  let (:test_invoice_item){SalesEngine::Item.new(test_attr)}

  describe "#invoice_items" do
    context "returns a collection of invoice items" do

      it "contains things which are only invoice items" do
        test_invoice_item.invoice_items.all?{|i| i.is_a? SalesEngine::InvoiceItem}.should == true
      end

      it "contains invoice items associated with only this item" do
        test_invoice_item.invoice_items.all? {|i|
          i.item_id == test_invoice_item.id}.should == true
      end

    end
  end
end