require './spec/spec_helper'

describe Merchant do
  let(:merchant) {Merchant.new(:id => 1, :name => "Test Merchant")}

  it 'creates a merchant with valid attributes' do
    merchant.nil?.should be_false
  end

  it "doesn't create merchant without arguments" do
    expect do
      Merchant.new() 
    end.to raise_error(ArgumentError)
  end

  context "created_at attribute" do
    it "responds to created_at" do
      merchant.should be_respond_to(:created_at)  
    end

    it "returns a DateTime object when created_at is called" do
      merchant.created_at.class.should == DateTime
    end

    it "assigns created_at when passed a DateTime argument" do
      date = DateTime.now
      merchant = Merchant.new(:id => 1, :name => "Test Merchant", :created_at => date)
      merchant.created_at.should == date
    end

    it "doesn't update created_at when a merchant's name changes" do
      old_created_at = merchant.created_at
      merchant.name = 'Jackie Chan'
      merchant.created_at.should == old_created_at
    end
  end

  context "updated_at attribute" do
    it "responds to updated_at" do
      merchant.should be_respond_to(:updated_at)  
    end

    it "returns a DateTime object when updated_at is called" do
      merchant.updated_at.class.should == DateTime
    end

    it "assigns updated_at when passed a DateTime argument" do
      date = DateTime.now
      merchant = Merchant.new(:id => 1, :name => "Test Merchant", :updated_at => date)
      merchant.updated_at.should == date
    end

    it "assigns updated_at to created_at for a new merchant" do
      merchant.created_at.should == merchant.updated_at
    end

    it "updates updated_at when a merchant's name changes" do
      old_updated_at = merchant.updated_at
      merchant.name = 'Jackie Chan'
      merchant.updated_at.should > old_updated_at
    end
  end

  context "id attribute" do
    it "doesn't create a merchant with a nil id" do
      expect do
        Merchant.new(:id => nil, :name => "Test Merchant") 
      end.to raise_error(ArgumentError)
    end

    it "has an id" do
      merchant.id.should_not be_nil
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
  end

  context "name attribute" do
    it "has a name" do
      merchant.name.should_not be_nil
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
  end

end








