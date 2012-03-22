require './spec/spec_helper'

describe SalesEngine::Item do
  let(:merchant) { SalesEngine::Merchant.new(:id => 1, :name => "Test Merchant") }

  let(:valid_item) do
    SalesEngine::Item.new(
      :id => 1, 
      :name => "Item 1", 
      :description => "Description",
      :unit_price => 12,
      :merchant => merchant
    )
  end

  context 'name' do
    it 'exists' do
      valid_item.name.should_not be_nil
    end

    it 'is assigned by the name argument' do
      valid_item.name.should == "Item 1"
    end

    it "raises ArgumentError if there isn't a name argument" do
      expect do
        SalesEngine::Item.new :id => 1
      end.to raise_error ArgumentError
    end

    it "can't be nil or an ArgumentError is raised" do
      expect do 
        SalesEngine::Item.new :id => 1, :name => nil 
      end.to raise_error ArgumentError
    end

    it "can't be blank or an ArgumentError is raised" do
      expect do 
        SalesEngine::Item.new :id => 1, :name => "" 
      end.to raise_error ArgumentError
    end
  end

  context 'description' do
    it 'exists' do
      valid_item.description.should_not be_nil
    end

    it 'is assigned by the description argument' do
      valid_item.description.should == "Description"
    end

    it "raises ArgumentError if there isn't a description argument" do
      expect do 
        SalesEngine::Item.new :id => 1, :name => "Item 1"
      end.to raise_error ArgumentError
    end

    it "can't be nil or an ArgumentError is raised" do
      expect do 
        SalesEngine::Item.new :id => 1, :name => "Item 1", :description => nil 
      end.to raise_error ArgumentError
    end

    it "can't be blank or an ArgumentError is raised" do
      expect do
        SalesEngine::Item.new :id => 1, :name => "Item 1", :description => "" 
      end.to raise_error ArgumentError
    end
  end

  context 'unit_price' do
    it 'exists' do
      valid_item.unit_price.should_not be_nil
    end

    it 'is assigned by the unit_price argument' do
      valid_item.unit_price.should == 12
    end

    it "raises ArgumentError if there isn't a unit_price argument" do
      expect do 
        SalesEngine::Item.new(
          :id => 1, 
          :name => "Item 1", 
          :description => "Description"
        )
      end.to raise_error ArgumentError
    end

    it "can't be nil or an ArgumentError is raised" do
      expect do 
        SalesEngine::Item.new(
          :id => 1, 
          :name => "Item 1", 
          :description => "Description",
          :unit_price => nil 
        )
      end.to raise_error ArgumentError
    end

    it "can't be blank or an ArgumentError is raised" do
      expect do
        SalesEngine::Item.new(
          :id => 1, 
          :name => "Item 1", 
          :description => "Description",
          :unit_price => "" 
        )
      end.to raise_error ArgumentError
    end

    it "raises an ArgumentError unless it's numeric" do
      expect do
        SalesEngine::Item.new(
          :id => 1, 
          :name => "Item 1", 
          :description => "Description",
          :unit_price => "Jackie Chan" 
        )
      end.to raise_error ArgumentError
    end
  end

  context "item's merchant" do
    it 'exists' do
      valid_item.merchant.should_not be_nil
    end

    it 'must be passed in as a parameter on creation' do
      expect do
        SalesEngine::Item.new(
          :id => 1, 
          :name => "Item 1", 
          :description => "Description",
          :unit_price => 12,
        )
      end.to raise_error ArgumentError
    end

    it "can't be nil or an exception is raised"
    it "can't be blank or an exception is raised"
  end
end
