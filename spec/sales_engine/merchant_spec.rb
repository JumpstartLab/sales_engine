require 'spec_helper'

describe SalesEngine::Merchant do
  let(:se) { SalesEngine::Database.instance}
  let(:merchant_1) { Fabricate(:merchant) }
  let(:merchant_2) { Fabricate(:merchant) }
  let(:merchant_3) { Fabricate(:merchant) }
  let(:item_1) { Fabricate(:item) }
  let(:item_2) { Fabricate(:item) }
  let(:item_3) { Fabricate(:item) }
  let(:invoice_1) { Fabricate(:invoice) }
  let(:invoice_2) { Fabricate(:invoice) }
  let(:invoice_3) { Fabricate(:invoice) }


  before(:each) do
    se.clear_all_data
    se.add_to_list(merchant_1)
    se.add_to_list(merchant_2)
    se.add_to_list(merchant_3)
    se.add_to_list(item_1)
    se.add_to_list(item_2)
    se.add_to_list(item_3)
    se.add_to_list(invoice_1)
    se.add_to_list(invoice_2)
    se.add_to_list(invoice_3)
  end

  describe "#items" do
    it "returns items associated with the merchant if items exists" do
      item_1.merchant_id = merchant_1.id
      item_2.merchant_id = merchant_1.id
      item_3.merchant_id = merchant_2.id
      merchant_1.items.should == [item_1, item_2]
    end

    it "returns an empty array if no items are associated with the merchant" do
      merchant_1.items.should == []
    end
  end

  describe "#invoices" do
    it "returns invoices associated with the merchant if invoices exist" do
      invoice_1.merchant_id = merchant_2.id
      invoice_2.merchant_id = merchant_1.id
      invoice_3.merchant_id = merchant_1.id
      merchant_1.invoices.should == [invoice_2, invoice_3]
    end

    it "returns an empty array if no invoices are associated with the merchant" do
      merchant_1.invoices.should == []
    end
  end

  describe ".random" do
    context "when merchants exist in the datastore" do
      it "returns a random Merchant record" do
        se.merchants.include?(SalesEngine::Merchant.random).should be_true
      end
    end

    context "when there are no merchants in the datastore" do
      it "returns nil" do
        se.clear_all_data
        SalesEngine::Merchant.random.should be_nil
      end
    end
  end

  describe ".find_by_id" do
    context "when merchants exist in the datastore" do
      it "returns the correct merchant record that matches the id" do
        SalesEngine::Merchant.find_by_id(merchant_2.id).should == merchant_2
      end

      it "returns nothing if no merchant records match the id" do
        SalesEngine::Merchant.find_by_id(100).should be_nil
      end
    end

    context "when there are no merchants in the datastore" do
      it "returns nothing" do
        se.clear_all_data
        SalesEngine::Merchant.find_by_id(merchant_1.id).should be_nil
      end
    end
  end
  
  describe ".find_by_name" do
    context "when merchants exist in the datastore" do
      before(:each) do
        merchant_1.name = "Jane"
        merchant_2.name = "beth"
      end

      it "returns the correct merchant record that matches the name" do
        SalesEngine::Merchant.find_by_name('Beth').should == merchant_2
      end

      it "returns nothing if no merchant records match the name" do
        SalesEngine::Merchant.find_by_name('conan').should be_nil
      end
    end

    context "when there are no merchants in the datastore" do
      it "returns nothing" do
        se.clear_all_data
        SalesEngine::Merchant.find_by_name('beth').should be_nil
      end
    end
  end
  
  describe ".find_by_created_at" do
    context "when merchants exist in the datastore" do
      before(:each) do
        merchant_1.created_at = "03/01/2012 12:00"
        merchant_2.created_at = "01/11/2012 13:00"
      end

      it "returns the correct merchant record that matches the created_at time" do
        SalesEngine::Merchant.find_by_created_at("01/11/2012 13:00").should == merchant_2
      end

      it "returns nothing if no merchant records match the created_at time" do
        SalesEngine::Merchant.find_by_created_at("01/11/1979 10:00").should be_nil
      end
    end

    context "when there are no merchants in the datastore" do
      it "returns nothing" do
        se.clear_all_data
        SalesEngine::Merchant.find_by_created_at("01/11/2012 13:00").should be_nil
      end
    end
  end
  
  describe ".find_by_updated_at" do
      context "when merchants exist in the datastore" do
      before(:each) do
        merchant_1.updated_at = "03/01/2012 12:00"
        merchant_2.updated_at = "01/11/2012 13:00"
      end

      it "returns the correct merchant record that matches the updated_at time" do
        SalesEngine::Merchant.find_by_updated_at("01/11/2012 13:00").should == merchant_2
      end

      it "returns nothing if no merchant records match the updated_at time" do
        SalesEngine::Merchant.find_by_updated_at("01/11/1979 10:00").should be_nil
      end
    end

    context "when there are no merchants in the datastore" do
      it "returns nothing" do
        se.clear_all_data
        SalesEngine::Merchant.find_by_updated_at("01/11/2012 13:00").should be_nil
      end
    end
  end
  
  describe ".find_all_by_id" do
    context "when merchants exist in the datastore" do
      it "returns the correct merchant records that matches the id" do
        SalesEngine::Merchant.find_all_by_id(merchant_2.id).should == [merchant_2]
      end

      it "returns nothing if no merchant records match the id" do
        SalesEngine::Merchant.find_all_by_id(100).should == []
      end
    end

    context "when there are no merchants in the datastore" do
      it "returns nothing" do
        se.clear_all_data
        SalesEngine::Merchant.find_all_by_id(merchant_1.id).should == []
      end
    end
  end

    describe ".find_all_by_name" do
    context "when merchants exist in the datastore" do
      before(:each) do
        merchant_1.name = "Jane"
        merchant_2.name = "Beth"
        merchant_3.name = "jane"
      end

      it "returns the correct merchant records that matches the name" do
        SalesEngine::Merchant.find_all_by_name("Jane").should == [merchant_1, merchant_3]
      end

      it "returns nothing if no merchant records match the name" do
        SalesEngine::Merchant.find_all_by_name('conan').should == []
      end
    end

    context "when there are no merchants in the datastore" do
      it "returns nothing" do
        se.clear_all_data
        SalesEngine::Merchant.find_all_by_name('beth').should == []
      end
    end
  end

  describe ".find_all_by_created_at" do
    context "when merchants exist in the datastore" do
      before(:each) do
        merchant_1.created_at = "03/01/2012 12:00"
        merchant_2.created_at = "01/11/2012 13:00"
        merchant_3.created_at = "01/11/2012 13:00"
      end

      it "returns the correct merchant records that matches the created_at time" do
        SalesEngine::Merchant.find_all_by_created_at("01/11/2012 13:00").should == [merchant_2, merchant_3]
      end

      it "returns nothing if no merchant records match the created_at time" do
        SalesEngine::Merchant.find_all_by_created_at("01/11/1979 10:00").should == []
      end
    end

    context "when there are no merchants in the datastore" do
      it "returns nothing" do
        se.clear_all_data
        SalesEngine::Merchant.find_all_by_created_at("01/11/2012 13:00").should == []
      end
    end
  end

  describe ".find_all_by_updated_at" do
      context "when merchants exist in the datastore" do
      before(:each) do
        merchant_1.updated_at = "03/01/2012 12:00"
        merchant_2.updated_at = "01/11/2012 13:00"
        merchant_3.updated_at = "01/11/2012 13:00"
      end

      it "returns the correct merchant records that matches the updated_at time" do
        SalesEngine::Merchant.find_all_by_updated_at("01/11/2012 13:00").should == [merchant_2, merchant_3]
      end

      it "returns nothing if no merchant records match the updated_at time" do
        SalesEngine::Merchant.find_all_by_updated_at("01/11/1979 10:00").should == []
      end
    end

    context "when there are no merchants in the datastore" do
      it "returns nothing" do
        se.clear_all_data
        SalesEngine::Merchant.find_all_by_updated_at("01/11/2012 13:00").should == []
      end
    end
  end

end