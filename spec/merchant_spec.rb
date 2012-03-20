require './spec/spec_helper'

describe Merchant do
  it 'creates a merchant with valid attributes' do
    merchant = Merchant.new(:id => 1, :name => "Test Merchant")
    merchant.nil?.should be_false
  end

  it "doesn't create a merchant with a nil id" do
    expect do
      Merchant.new(:id => nil, :name => "Test Merchant") 
    end.to raise_error(ArgumentError)
  end

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
end