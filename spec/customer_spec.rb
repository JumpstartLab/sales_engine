require 'spec_helper'

describe SalesEngine::Customer do
  let(:valid_customer) { Fabricate(:customer) }

  it "assigns a customer name when given as an attribute" do
    first, last = 'Jackie', 'Chan'
    customer = SalesEngine::Customer.new :id => 1, :first_name => first, :last_name => last
    customer.first_name.should == first
  end

  context "first_name" do
    it "exists" do
      expect do
        SalesEngine::Customer.new :id => 1, :last_name => 'Chan'
      end.to raise_error ArgumentError
    end

    it "isn't blank" do
      valid_customer.first_name.should_not be_empty
    end
  end

  context "last_name" do
    it "exists" do
      expect do
        SalesEngine::Customer.new :id => 1, :first_name => 'Jackie'
      end.to raise_error ArgumentError
    end

    it "isn't blank" do
      valid_customer.last_name.should_not be_empty
    end

    it "can be blank" do
      SalesEngine::Customer.new :id => 1, :first_name => 'Jackie', :last_name => ''
    end
  end

  context "can't be created if" do
    it "first_name is blank" do
      expect do
        SalesEngine::Customer.new :id => 1, :first_name => '', :last_name => 'Chan'
      end.to raise_error ArgumentError
    end
  end
end
