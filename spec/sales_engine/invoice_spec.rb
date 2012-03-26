require 'spec_helper'

describe SalesEngine::Invoice do
  describe 'initialize' do
    context "when instantiating a new invoice" do
    let(:invoice) {SalesEngine::Invoice.new({:id => 1, :customer_id => 1, :merchant_id => 3, :status => "text", :created_at => "text", :updated_at => "text"})}
      it "sets id" do
        invoice.id.should == 1
      end
    end
  end
  
end