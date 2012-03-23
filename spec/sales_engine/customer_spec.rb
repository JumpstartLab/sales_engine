require 'spec_helper'

describe SalesEngine::Customer do
  describe 'initialize' do
    context "when instantiating a new customer" do
    let(:customer) {SalesEngine::Customer.new({:id => 1, :first_name => "john", :last_name => "ben", :created_at => "time", :updated_at => "time"})}
      it "sets id" do
        customer.id.should == 1
      end
    end
  end
  
end