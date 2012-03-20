require './lib/merchant'
require './lib/database'
require './spec/spec_helper'

describe Merchant do
  describe ".random" do
    context "when database has merchants loaded" do
      before(:each) do
        @merchants = 10.times.collect { mock(Merchant) } 
        Database.stub(:merchants).and_return(@merchants)
      end

      it "returns a random object from merchants array" do
        Random.stub(:rand).and_return(5)
        Merchant.random.should == @merchants[5]
      end

      it "returns a merchant" do
        puts Merchant.random.inspect
        Merchant.random.is_a?(mock(Merchant).class).should == true
      end
    end

    context "when database has no merchants" do
      it "returns nil" do
        Merchant.random.should == nil
      end
    end
  end

  describe ".find_by_id" do
    context "when database has merchants loaded" do
      let(:merchant) { mock(Merchant) }
      let(:merchant2) { mock(Merchant) }
      let(:merchant3) { mock(Merchant) }

      before(:each) do        
        merchant.stub(:id).and_return(1)
        merchant2.stub(:id).and_return(2)
        merchant3.stub(:id).and_return(3)
        Database.stub(:merchants).and_return([merchant, merchant2, merchant3])
      end

      context "merchant with id is in database" do
        it "returns merchant" do
          Merchant.find_by_id(2).should == merchant2
        end
      end
      context "merchant with id is not in database" do
        it "returns nil" do
          Merchant.find_by_id(6).should == nil
        end
      end
    end

    context "when database has no merchants" do
      it "returns nil" do
        Merchant.find_by_id(2).should == nil
      end
    end
  end
end