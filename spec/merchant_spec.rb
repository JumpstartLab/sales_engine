require 'spec_helper'

describe SalesEngine::Merchant do
  let(:merchant) { Fabricate(:merchant) }

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

  # spec_evaluation

  context "Searching" do
    describe ".random" do
      it "usually returns different things on subsequent calls" do
        merchant_one = SalesEngine::Merchant.random
        merchant_two = nil

        10.times do
          merchant_two = SalesEngine::Merchant.random
          break if merchant_one.id != merchant_two.id
        end

        merchant_one.id.should_not == merchant_two.id
      end
    end

    it ".find_by_name" do
      merchant = SalesEngine::Merchant.find_by_name "Marvin Group"
      merchant.should_not be_nil
    end

    it ".find_by_all_name" do
      merchants = SalesEngine::Merchant.find_all_by_name "Williamson Group"
      merchants.should have(2).merchants
    end
  end

  context "Relationships" do
    let(:merchant) { SalesEngine::Merchant.find_by_name "Kirlin, Jakubowski and Smitham" }

    describe "#items" do
      it "has 33 of them" do
        merchant.items.should have(33).items
      end

      it "includes an 'Item Consequatur Odit'" do
        item = merchant.items.find {|i| i.name == 'Item Consequatur Odit' }
        item.should_not be_nil
      end
    end

    describe "#invoices" do
      it "has 52 of them" do
        merchant.invoices.should have(43).invoices
      end

    #   it "has a shipped invoice for Block" do
    #     invoice = merchant.invoices.find {|i| i.customer.last_name = 'Block' }
    #     invoice.status.should == "shipped"
    #   end
    end
  end
end
