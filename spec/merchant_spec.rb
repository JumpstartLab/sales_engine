require 'spec_helper'

describe SalesEngine::Merchant do
  let(:merchant) { Fabricate(:merchant) }

  before(:all) { SalesEngine.startup('data/evaluation') }

  it 'creates a merchant with valid attributes' do
    merchant.nil?.should be_false
  end

  it "doesn't create merchant without arguments" do
    expect do
      SalesEngine::Merchant.new() 
    end.to raise_error(ArgumentError)
  end

  context "name attribute" do
    it "has a name" do
      merchant.name.should_not be_nil
    end

    it "doesn't create a merchant with a nil name" do
      expect do
        SalesEngine::Merchant.new(:id => 1, :name => nil) 
      end.to raise_error(ArgumentError)
    end

    it "doesn't create a merchant with a blank name" do
      expect do
        SalesEngine::Merchant.new(:id => 1, :name => "") 
      end.to raise_error(ArgumentError)
    end
  end

  context "updated_at" do
    it "is updated when a valid_sample's name changes" do
      old_updated_at = merchant.updated_at
      merchant.name = 'Jackie Chan'
      merchant.updated_at.should > old_updated_at
    end
  end

  context "created_at" do
    it "is not updated when a merchant's name changes" do
      old_created_at = merchant.created_at
      merchant.name = 'Jackie Chan'
      merchant.created_at.should == old_created_at
    end
  end
end
