require 'spec_helper'

describe SalesEngine::InvoiceItem do
  describe ".item" do
    let(:invoice_item) { SalesEngine::InvoiceItem.new(1, 1, 1, 1, 0, Date.today, Date.today) }
    let(:item) { mock(SalesEngine::Item) }
    let(:other_item) { mock(SalesEngine::Item) }

    before(:each) do
      item.stub(:id).and_return(1)
      other_item.stub(:id).and_return(2)
      SalesEngine::Database.stub(:items).and_return([item, other_item])
    end
    
    it "returns the item with matching item_id" do
      invoice_item.item.should == item
    end
  end
end