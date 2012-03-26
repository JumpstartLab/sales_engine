require 'spec_helper'

describe SalesEngine::Customer do
  let(:customer) {SalesEngine::Customer.new({:id => 1, :first_name => "john", :last_name => "ben", :created_at => "time", :updated_at => "time"})}
  describe 'initialize' do
    context "when instantiating a new customer" do
      it 'receives a hash as a param' do
        param = {:id => 1, :first_name => "john", :last_name => "ben", :created_at => "time", :updated_at => "time"}
        param.should be_a(Hash)
      end
      [:id, :first_name, :last_name, :created_at, :updated_at].each do |method|
        it "sets the customer's attribute #{method} with the method #{method}" do
          customer.send(method).should_not be_nil
        end
      end
    end
  end
end