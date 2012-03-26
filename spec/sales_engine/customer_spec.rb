require 'spec_helper'

describe SalesEngine::Customer do
  let(:customer) {SalesEngine::Customer.new({:id => 1, :first_name => "john", :last_name => "ben", :created_at => "time", :updated_at => "time"})}
  describe 'initialize' do
    context "when instantiating a new customer" do
      it "sets id" do
        customer.id.should_not be_nil
      end
      it 'sets first_name' do
        customer.first_name.should_not be_nil
      end
      it 'sets last_name' do
        customer.last_name.should_not be_nil
      end
      it 'sets created_at' do
        customer.created_at.should_not be_nil
      end
      it 'sets updated_at' do
        customer.updated_at.should_not be_nil
      end
      it 'receives a hash as a param' do
        param = {:id => 1, :first_name => "john", :last_name => "ben", :created_at => "time", :updated_at => "time"}
        param.should be_a(Hash)
      end
    end
  end
end