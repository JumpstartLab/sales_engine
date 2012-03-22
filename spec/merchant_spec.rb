require 'spec_helper'

describe SalesEngine::Merchant do
  describe ".random" do
    context "when database has merchants loaded" do
      before(:each) do
        @merchants = 10.times.collect { mock(SalesEngine::Merchant) } 
        SalesEngine::Database.stub(:merchants).and_return(@merchants)
      end

      it "returns a random object from merchants array" do
        Random.stub(:rand).and_return(5)
        SalesEngine::Merchant.random.should == @merchants[5]
      end

      it "returns a merchant" do
        SalesEngine::Merchant.random.is_a?(mock(SalesEngine::Merchant).class).should == true
      end
    end

    context "when database has no merchants" do
      it "returns nil" do
        SalesEngine::Merchant.random.should == nil
      end
    end
  end

  describe ".find_by" do
    let(:merchant) { mock(SalesEngine::Merchant) }
    let(:merchant2) { mock(SalesEngine::Merchant) }
    let(:merchant3) { mock(SalesEngine::Merchant) }
    let(:duplicate_merchant) { mock(SalesEngine::Merchant) }
    let(:merchants) { [merchant, merchant2, merchant3, duplicate_merchant] }

    before(:each) do
      merchant.stub(:id).and_return(1)
      merchant2.stub(:id).and_return(2)
      merchant3.stub(:id).and_return(3)
      duplicate_merchant.stub(:id).and_return(1)
    end

    it "calls find_by attribute" do
      SalesEngine::Database.stub(:merchants).and_return(merchants)
      SalesEngine::Merchant.find_by_id(2).should == merchant2
    end
  end

  describe ".find_all_by" do
    let(:merchant) { mock(SalesEngine::Merchant) }
    let(:merchant2) { mock(SalesEngine::Merchant) }
    let(:duplicate_merchant) { mock(SalesEngine::Merchant) }
    let(:merchants) { [merchant, merchant2, duplicate_merchant] }

    before(:each) do
      merchant.stub(:id).and_return(1)
      merchant2.stub(:id).and_return(2)
      duplicate_merchant.stub(:id).and_return(1)
    end

    it "calls find_all_by attribute" do
      SalesEngine::Database.stub(:merchants).and_return(merchants)
      SalesEngine::Merchant.find_all_by_id(1).should == [merchant, duplicate_merchant]
    end
  end

  describe "method missing" do
    it "invokes the normal no method error" do
      expect{SalesEngine::Merchant.foo}.should raise_error
    end
  end

  describe "respond to" do
    let(:merchant) { SalesEngine::Merchant.new(1, "Name", Date.today, Date.today)}
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
    let(:invoice1) { mock(SalesEngine::Invoice) }
    let(:invoice2) { mock(SalesEngine::Invoice) }
    let(:invoice3) { mock(SalesEngine::Invoice) }

    before(:each) do
      invoice1.stub(:merchant_id).and_return(1)
      invoice2.stub(:merchant_id).and_return(2)
      invoice3.stub(:merchant_id).and_return(1)

      invoices = [invoice1, invoice2, invoice3]
      SalesEngine::Database.stub(:invoices).and_return(invoices)
    end


    context "when merchant has one invoice" do
      it "returns an array containing the single invoice" do
        merchant = SalesEngine::Merchant.new(2, "", "", "")
        merchant.invoices.should == [invoice2]
      end
    end

    context "when merchant has multiple invoices" do
      it "returns all invoices" do
        merchant = SalesEngine::Merchant.new(1, "", "", "")
        merchant.invoices.should == [invoice1, invoice3]
      end
    end

    context "when merchant has no invoices" do
      it "returns an empty array" do
        merchant = SalesEngine::Merchant.new(3, "", "", "")
        merchant.invoices.should == []
      end
    end
  end

  describe "#items" do
    let(:item1) { mock(SalesEngine::Item) }
    let(:item2) { mock(SalesEngine::Item) }
    let(:item3) { mock(SalesEngine::Item) }

    before(:each) do
      item1.stub(:merchant_id).and_return(1)
      item2.stub(:merchant_id).and_return(2)
      item3.stub(:merchant_id).and_return(1)

      items = [item1, item2, item3]
      SalesEngine::Database.stub(:items).and_return(items)
    end


    context "when merchant has one item" do
      it "returns an array containing the single item" do
        merchant = SalesEngine::Merchant.new(2, "", "", "")
        merchant.items.should == [item2]
      end
    end

    context "when merchant has multiple items" do
      it "returns all items" do
        merchant = SalesEngine::Merchant.new(1, "", "", "")
        merchant.items.should == [item1, item3]
      end
    end

    context "when merchant has no items" do
      it "returns an empty array" do
        merchant = SalesEngine::Merchant.new(3, "", "", "")
        merchant.items.should == []
      end
    end
  end
end