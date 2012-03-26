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
  describe 'initialize' do
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
end