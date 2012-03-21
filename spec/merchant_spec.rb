require './spec/spec_helper'

describe Merchant do
  let(:merchant) {Merchant.new(:id => 1, :name => "Test Merchant")}

  it 'creates a merchant with valid attributes' do
    merchant.nil?.should be_false
  end

  it "doesn't create a merchant with a nil id" do
    expect do
      Merchant.new(:id => nil, :name => "Test Merchant") 
    end.to raise_error(ArgumentError)
  end

  it "has an id" do
    merchant.id.should_not be_nil
  end

  it "has a name"

  it "doesn't create a merchant with a blank id" do
    expect do
      Merchant.new(:id => "", :name => "Test Merchant") 
    end.to raise_error(ArgumentError)
  end

  it "doesn't create a merchant without a numeric id" do
    expect do
      Merchant.new(:id => "apple", :name => "Test Merchant") 
    end.to raise_error(ArgumentError)
  end

  it "doesn't create a merchant with a nil name" do
    expect do
      Merchant.new(:id => 1, :name => nil) 
    end.to raise_error(ArgumentError)
  end

  it "doesn't create a merchant with a blank name" do
    expect do
      Merchant.new(:id => 1, :name => "") 
    end.to raise_error(ArgumentError)
  end

  it "doesn't create merchant without arguments" do
    expect do
      Merchant.new() 
    end.to raise_error(ArgumentError)
  end

  it "responds to created_at" do
    merchant.should be_respond_to(:created_at)  
  end

  it "returns a DateTime object when created_at is called" do
    merchant.created_at.class.should == DateTime
  end
end








