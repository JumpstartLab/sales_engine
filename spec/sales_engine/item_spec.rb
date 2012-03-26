require 'spec_helper'

describe SalesEngine::Item do
  describe 'initialize' do
    context 'when instantiating a new object' do
      let(:item){SalesEngine::Item.new({:id => 1, :name => "text", :description => "text", :unit_price => "price", :merchant_id => 3, :created_at => "time", :updated_at => "time"})}
      it 'sets id' do
        item.id.should == 1
      end
    end
  end
  
end