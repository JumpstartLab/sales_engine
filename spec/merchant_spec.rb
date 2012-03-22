require './spec/spec_helper'

describe Merchant do
  let(:se) { Database.instance}
  let(:merchant_1) { Merchant.new({ :id => 1 }) }
  let(:merchant_2) { Merchant.new({ :id => 2 }) }

  before(:each) do
    se.clear_all_data
    se.add_to_list(merchant_1)
    se.add_to_list(merchant_2)
  end

  describe "#items" do
    it "returns items associated with the merchant if items exists" do
      item_1 = Item.new({ :id => 1, :merchant_id => nil })
      item_2 = item_1.clone
      item_2.id = 2
      item_3 = item_1.clone
      item_3.id = 3
      item_1.merchant_id = 1
      item_2.merchant_id = 1
      item_3.merchant_id = 2
      se.add_to_list(item_1)
      se.add_to_list(item_2)
      se.add_to_list(item_3)
      merchant_1.items.should == [item_1, item_2]
    end

    it "returns an empty array if no items are associated with the merchant" do
      merchant_1.items.should == []
    end
  end

  describe "#invoices" do
    it "returns invoices associated with the merchant if invoices exist" do
      invoice_1 = Invoice.new({ :id => 1, :merchant_id => nil })
      invoice_2 = invoice_1.clone
      invoice_2.id = 2    
      invoice_3 = invoice_1.clone
      invoice_3.id = 3
      invoice_1.merchant_id = 2
      invoice_2.merchant_id = 1
      invoice_3.merchant_id = 1
      se.add_to_list(invoice_1)
      se.add_to_list(invoice_2)
      se.add_to_list(invoice_3)
      merchant_1.invoices.should == [invoice_2, invoice_3]
    end

    it "returns an empty array if no invoices are associated with the merchant" do
      merchant_1.invoices.should == []
    end
  end

  describe ".random" do
    let(:merchant_3) { Merchant.new({ :id => 3 }) }

    context "when merchants exist in the datastore" do
      it "returns a random Merchant record" do
        se.merchants.include?(Merchant.random).should be_true
      end
    end

    context "when there are no merchants in the datastore" do
      it "returns nil" do
        se.clear_all_data
        Merchant.random.should be_nil
      end
    end
  end

  describe ".find_by_id" do
    context "when merchants exist in the datastore" do
      it "returns the correct merchant record that matches the id" do
        Merchant.find_by_id(2).should == merchant_2
      end

      it "returns nothing if no merchant records match the id" do
        Merchant.find_by_id(100).should be_nil
      end
    end

    context "when there are no merchants in the datastore" do
      it "returns nothing" do
        se.clear_all_data
        Merchant.find_by_id(1).should be_nil
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
        Merchant.find_by_name('Beth').should == merchant_2
      end

      it "returns nothing if no merchant records match the name" do
        Merchant.find_by_name('conan').should be_nil
      end
    end

    context "when there are no merchants in the datastore" do
      it "returns nothing" do
        se.clear_all_data
        Merchant.find_by_name('beth').should be_nil
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
        Merchant.find_by_created_at("01/11/2012 13:00").should == merchant_2
      end

      it "returns nothing if no merchant records match the created_at time" do
        Merchant.find_by_created_at("01/11/1979 10:00").should be_nil
      end
    end

    context "when there are no merchants in the datastore" do
      it "returns nothing" do
        se.clear_all_data
        Merchant.find_by_created_at("01/11/2012 13:00").should be_nil
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
        Merchant.find_by_updated_at("01/11/2012 13:00").should == merchant_2
      end

      it "returns nothing if no merchant records match the updated_at time" do
        Merchant.find_by_updated_at("01/11/1979 10:00").should be_nil
      end
    end

    context "when there are no merchants in the datastore" do
      it "returns nothing" do
        se.clear_all_data
        Merchant.find_by_updated_at("01/11/2012 13:00").should be_nil
      end
    end
  end
  
  describe ".find_all_by_id" do
    context "when merchants exist in the datastore" do
      it "returns the correct merchant records that matches the id" do
        Merchant.find_all_by_id(2).should == [merchant_2]
      end

      it "returns nothing if no merchant records match the id" do
        Merchant.find_all_by_id(100).should == []
      end
    end

    context "when there are no merchants in the datastore" do
      it "returns nothing" do
        se.clear_all_data
        Merchant.find_all_by_id(1).should == []
      end
    end
  end

    describe ".find_all_by_name" do
    context "when merchants exist in the datastore" do
      let(:merchant_3) { Merchant.new({ :id => 3 }) }

      before(:each) do
        merchant_1.name = "Jane"
        merchant_2.name = "Beth"
        merchant_3.name = "jane"
        se.add_to_list(merchant_3)
      end

      it "returns the correct merchant records that matches the name" do
        Merchant.find_all_by_name("Jane").should == [merchant_1, merchant_3]
      end

      it "returns nothing if no merchant records match the name" do
        Merchant.find_all_by_name('conan').should == []
      end
    end

    context "when there are no merchants in the datastore" do
      it "returns nothing" do
        se.clear_all_data
        Merchant.find_all_by_name('beth').should == []
      end
    end
  end

  describe ".find_all_by_created_at" do
    context "when merchants exist in the datastore" do
      let(:merchant_3) { Merchant.new({ :id => 3 }) }

      before(:each) do
        merchant_1.created_at = "03/01/2012 12:00"
        merchant_2.created_at = "01/11/2012 13:00"
        merchant_3.created_at = "01/11/2012 13:00"
        se.add_to_list(merchant_3)
      end

      it "returns the correct merchant records that matches the created_at time" do
        Merchant.find_all_by_created_at("01/11/2012 13:00").should == [merchant_2, merchant_3]
      end

      it "returns nothing if no merchant records match the created_at time" do
        Merchant.find_all_by_created_at("01/11/1979 10:00").should == []
      end
    end

    context "when there are no merchants in the datastore" do
      it "returns nothing" do
        se.clear_all_data
        Merchant.find_all_by_created_at("01/11/2012 13:00").should == []
      end
    end
  end

  describe ".find_all_by_updated_at" do
      context "when merchants exist in the datastore" do
      let(:merchant_3) { Merchant.new({ :id => 3 }) }
      before(:each) do
        merchant_1.updated_at = "03/01/2012 12:00"
        merchant_2.updated_at = "01/11/2012 13:00"
        merchant_3.updated_at = "01/11/2012 13:00"
        se.add_to_list(merchant_3)
      end

      it "returns the correct merchant records that matches the updated_at time" do
        Merchant.find_all_by_updated_at("01/11/2012 13:00").should == [merchant_2, merchant_3]
      end

      it "returns nothing if no merchant records match the updated_at time" do
        Merchant.find_all_by_updated_at("01/11/1979 10:00").should == []
      end
    end

    context "when there are no merchants in the datastore" do
      it "returns nothing" do
        se.clear_all_data
        Merchant.find_all_by_updated_at("01/11/2012 13:00").should == []
      end
    end
  end

end