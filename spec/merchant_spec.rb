require './lib/merchant'
require './lib/database'
require 'spec_helper'

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
end