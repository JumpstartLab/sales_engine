require 'spec_helper'

describe SalesEngine::Item do
  param = {:id => 1, 
           :name => "Item Necessitatibus Facilis", 
           :description => "Omnis error accusantium est ea enim sint. Vero accusantium voluptatem natus et commodi deleniti. Autem soluta omnis in qui commodi. Qui corporis est ut blanditiis. Sit corrupti magnam sit dolores nostrum unde esse.", 
           :unit_price => 16180, 
           :merchant_id => 1, 
           :created_at => "2012-02-26 20:56:50 UTC", 
           :updated_at => "2012-02-26 20:56:50 UTC"}
  let(:item) {SalesEngine::Item.new(param)}
  #let(:item) { Fabricate(:item) }
  describe '#initialize' do
    context "when instantiating a new item" do
      it 'receives a hash as a param' do
        param.should be_a(Hash)
      end
      [:id, :name, :description, :unit_price, :merchant_id, :created_at, :updated_at].each do |method|
        it "sets the item's attribute #{method} with the method #{method}" do
          item.send(method).should_not be_nil
        end
      end
    end
  end

  let(:collection) {SalesEngine::Database.instance.items}
  describe '.collection' do
    it 'creates an array' do
      collection.should be_a(Array)
    end
    it 'contains instances of the item class' do
      collection.first.class.should == item.class
    end
    it 'is not nil' do
      collection.should_not be_nil
    end
  end

  let(:invoiceitem){SalesEngine::Database.instance.invoiceitems}
  let(:items){SalesEngine::Database.instance.items}
  describe '#invoice_items' do
    it 'creates an array' do
      item.invoice_items.should be_a(Array)
    end
    it 'returns an instance of item' do
      results = items[0].invoice_items
      results[0].class.should == invoiceitem[0].class
    end
    it 'returns an empty array when no match' do
      item.invoice_items.should == []
    end
    it 'produces invoice items whose item_id
        matches the instantiated item\'s id' do
      test_invoiceitem = items[0].invoice_items.first
      test_invoiceitem.item_id.should == items[0].id
    end
  end
  describe '#merchant' do
    it 'returns a matched Merchant' do
      items[0].merchant.class.should == SalesEngine::Merchant
    end
    it 'produces a merchant whose id matches
        the instantiated item\'s merchant_id' do
      test_merchant = items[0].merchant
      test_merchant.id.should == items[0].merchant_id
    end
  end
end