require 'spec_helper'

describe SalesEngine::Merchant do
  describe 'initialize' do
    context "when instantiating a new merchant" do
    let(:merchant) {SalesEngine::Merchant.new({:id => 1, :name => "text", :created_at => "time", :updated_at => "time"})}
      it "sets id" do
        merchant.id.should == 1
      end
    end
  end
  
end