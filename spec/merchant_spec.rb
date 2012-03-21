require './lib/merchant'
require './lib/invoice'
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

  describe ".find_by" do
    let(:merchant) { mock(Merchant) }
    let(:merchant2) { mock(Merchant) }
    let(:merchant3) { mock(Merchant) }
    let(:duplicate_merchant) { mock(Merchant) }
    let(:merchants) { [merchant, merchant2, merchant3, duplicate_merchant] }

    before(:each) do
      merchant.stub(:id).and_return(1)
      merchant2.stub(:id).and_return(2)
      merchant3.stub(:id).and_return(3)
      duplicate_merchant.stub(:id).and_return(1)
    end

    it "calls find_by attribute" do
      Database.stub(:merchants).and_return(merchants)
      Merchant.find_by_id(2).should == merchant2
    end
  end

  describe ".find_all_by" do
    let(:merchant) { mock(Merchant) }
    let(:merchant2) { mock(Merchant) }
    let(:duplicate_merchant) { mock(Merchant) }
    let(:merchants) { [merchant, merchant2, duplicate_merchant] }

    before(:each) do
      merchant.stub(:id).and_return(1)
      merchant2.stub(:id).and_return(2)
      duplicate_merchant.stub(:id).and_return(1)
    end

    it "calls find_all_by attribute" do
      Database.stub(:merchants).and_return(merchants)
      Merchant.find_all_by_id(1).should == [merchant, duplicate_merchant]
    end
  end

  describe "method missing" do
    it "invokes the normal no method error" do
      expect{Merchant.foo}.should raise_error
    end
  end

  describe "respond to" do
    let(:merchant) { Merchant.new(1, "Name", Date.today, Date.today)}
    it "returns true for find_by" do
      merchant.respond_to?("find_by_id").should == true
    end
    it "returns true for find_all_by" do
      merchant.respond_to?("find_all_by_id").should == true
    end
    it "returns false for a method that doesn't exist" do
      merchant.respond_to?("foo").should == false
    end
  end

  describe "#invoices" do
    let(:invoice1) { mock(Invoice) }
    let(:invoice2) { mock(Invoice) }
    let(:invoice3) { mock(Invoice) }

    before(:each) do
      invoice1.stub(:merchant_id).and_return(1)
      invoice2.stub(:merchant_id).and_return(2)
      invoice3.stub(:merchant_id).and_return(1)

      invoices = [invoice1, invoice2, invoice3]
      Database.stub(:invoices).and_return(invoices)
    end


    context "when merchant has one invoice" do
      it "returns an array containing the single invoice" do
        merchant = Merchant.new(2, "", "", "")
        merchant.invoices.should == [invoice2]
      end
    end

    context "when merchant has multiple invoices" do
      it "returns all invoices" do
        merchant = Merchant.new(1, "", "", "")
        merchant.invoices.should == [invoice1, invoice3]
      end
    end

    context "when merchant has no invoices" do
      it "returns an empty array" do
        merchant = Merchant.new(3, "", "", "")
        merchant.invoices.should == []
      end
    end
  end
end