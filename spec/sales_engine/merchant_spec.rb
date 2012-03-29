require 'spec_helper'

describe SalesEngine::Merchant do
  let(:se) { SalesEngine::Database.instance}
  let(:merchant_1) { Fabricate(:merchant) }
  let(:merchant_2) { Fabricate(:merchant) }
  let(:merchant_3) { Fabricate(:merchant) }
  let(:merchant_4) { Fabricate(:merchant) }
  let(:merchant_5) { Fabricate(:merchant) }
  let(:item_1) { Fabricate(:item) }
  let(:item_2) { Fabricate(:item) }
  let(:item_3) { Fabricate(:item) }
  let(:customer_1) { Fabricate(:customer) }
  let(:customer_2) { Fabricate(:customer) }
  let(:customer_3) { Fabricate(:customer) }
  let(:invoice_1) { Fabricate(:invoice, :merchant_id => merchant_1.id, :customer_id => customer_1.id) }
  let(:invoice_2) { Fabricate(:invoice, :merchant_id => merchant_2.id, :customer_id => customer_1.id) }
  let(:invoice_3) { Fabricate(:invoice, :merchant_id => merchant_3.id, :customer_id => customer_3.id) }
  let(:invoice_4) { Fabricate(:invoice, :merchant_id => merchant_4.id, :customer_id => customer_1.id) }
  let(:invoice_5) { Fabricate(:invoice, :merchant_id => merchant_1.id, :customer_id => customer_2.id) }
  let(:invoice_6) { Fabricate(:invoice, :merchant_id => merchant_2.id, :customer_id => customer_3.id) }
  let(:invoice_7) { Fabricate(:invoice, :merchant_id => merchant_1.id, :customer_id => customer_2.id) }
  let(:transaction_1) { Fabricate(:transaction, :invoice_id => invoice_1.id, :result => "Success") }
  let(:transaction_2) { Fabricate(:transaction, :invoice_id => invoice_2.id, :result => "Success") }
  let(:transaction_3) { Fabricate(:transaction, :invoice_id => invoice_3.id, :result => "Success") }
  let(:transaction_4) { Fabricate(:transaction, :invoice_id => invoice_4.id, :result => "Success") }
  let(:transaction_5) { Fabricate(:transaction, :invoice_id => invoice_5.id, :result => "Success") }
  let(:transaction_6) { Fabricate(:transaction, :invoice_id => invoice_6.id, :result => "Success") }
  let(:transaction_7) { Fabricate(:transaction, :invoice_id => invoice_7.id, :result => "Success") }
  let(:invoice_item_1) { Fabricate(:invoice_item, :invoice_id => invoice_1.id, :unit_price => 1) }
  let(:invoice_item_2) { Fabricate(:invoice_item, :invoice_id => invoice_2.id, :unit_price => 1) }
  let(:invoice_item_3) { Fabricate(:invoice_item, :invoice_id => invoice_3.id, :unit_price => 1) }
  let(:invoice_item_4) { Fabricate(:invoice_item, :invoice_id => invoice_4.id, :unit_price => 5) }
  let(:invoice_item_5) { Fabricate(:invoice_item, :invoice_id => invoice_5.id, :unit_price => 1) }
  let(:invoice_item_6) { Fabricate(:invoice_item, :invoice_id => invoice_6.id, :unit_price => 2) }
  let(:invoice_item_7) { Fabricate(:invoice_item, :invoice_id => invoice_7.id, :unit_price => 2) }
  let(:invoice_item_8) { Fabricate(:invoice_item, :invoice_id => invoice_1.id, :unit_price => 3) }
  let(:invoice_item_9) { Fabricate(:invoice_item, :invoice_id => invoice_2.id, :unit_price => 20) }
  let(:invoice_item_10) { Fabricate(:invoice_item, :invoice_id => invoice_3.id, :unit_price => 1) }
  let(:invoice_item_11) { Fabricate(:invoice_item, :invoice_id => invoice_1.id, :unit_price => 4) }



  before(:each) do
    se.clear_all_data
    se.add_to_list(merchant_1)
    se.add_to_list(merchant_2)
    se.add_to_list(merchant_3)
    se.add_to_list(merchant_4)
    se.add_to_list(merchant_5)
    se.add_to_list(item_1)
    se.add_to_list(item_2)
    se.add_to_list(item_3)
    se.add_to_list(customer_1)
    se.add_to_list(customer_2)
    se.add_to_list(customer_3)
    se.add_to_list(invoice_1)
    se.add_to_list(invoice_2)
    se.add_to_list(invoice_3)
    se.add_to_list(invoice_4)
    se.add_to_list(invoice_5)
    se.add_to_list(invoice_6)
    se.add_to_list(invoice_7)
    se.add_to_list(transaction_1)
    se.add_to_list(transaction_2)
    se.add_to_list(transaction_3)
    se.add_to_list(transaction_4)
    se.add_to_list(transaction_5)
    se.add_to_list(transaction_6)
    se.add_to_list(transaction_7)
    se.add_to_list(invoice_item_1)
    se.add_to_list(invoice_item_2)
    se.add_to_list(invoice_item_3)
    se.add_to_list(invoice_item_4)
    se.add_to_list(invoice_item_5)
    se.add_to_list(invoice_item_6)
    se.add_to_list(invoice_item_7)
    se.add_to_list(invoice_item_8)
    se.add_to_list(invoice_item_9)
    se.add_to_list(invoice_item_10)
    se.add_to_list(invoice_item_11)
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
      merchant_1.invoices.should == [invoice_1, invoice_5, invoice_7]
    end

    it "returns an empty array if no invoices are associated with the merchant" do
      merchant_5.invoices.should == []
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

  describe ".most_revenue" do
    it "returns the top x merchant instances ranked by total revenue" do
      SalesEngine::Merchant.most_revenue(3).should == [merchant_2, merchant_1, merchant_4]
    end
  end

  describe ".most_items" do
    it "returns the top x merchant instances ranked by total number of items sold" do
      SalesEngine::Merchant.most_items(2).should == [merchant_1, merchant_2]
    end
  end

  describe ".revenue" do
    before(:each) do 
      invoice_1.created_at = "2012-03-14 20:56:56 UTC"
      invoice_2.created_at = "2012-03-14 07:01:36 UTC"
      invoice_3.created_at = "2012-03-14 23:56:23 UTC"
      invoice_4.created_at = "2012-03-14 12:29:01 UTC"
      invoice_5.created_at = "2012-02-01 00:51:56 UTC"
      invoice_6.created_at = "2012-03-14 20:00:51 UTC"
      invoice_7.created_at = "2012-02-01 16:16:41 UTC"    
    end

    it "returns the total revenue for that date across all merchants" do
      SalesEngine::Merchant.revenue(Date.parse("2012-03-14")).should == 38
    end

    it "returns 0 if no sales were made for that date" do
      SalesEngine::Merchant.revenue(Date.parse("2012-01-21")).should == 0
    end
  end

  describe "#revenue" do
    it "returns the total revenue for that merchant across all transactions" do
      merchant_1.revenue.should == 11
    end
  end

  describe "#revenue(date)" do
    before(:each) do 
      invoice_1.created_at = "2012-02-01 00:51:56 UTC"
      invoice_5.created_at = "2012-03-14 20:56:56 UTC"
      invoice_7.created_at = "2012-02-01 16:16:41 UTC"    
    end

    it "returns the total revenue that merchant for a specific date" do
      merchant_1.revenue(Date.parse("2012-02-01")).should == 10
    end
  end

  describe "#favorite_customer" do
    it "returns the Customer who has conducted the most transactions" do
      merchant_1.favorite_customer.should == customer_2
    end
  end

  describe "#customers_with_pending_invoices" do
    it "returns a collection of Customer instances which have pending (unpaid) invoices" do
      transaction_1.result = "failed"
      transaction_5.result = "failed"
      merchant_1.customers_with_pending_invoices.should == [customer_1, customer_2]
    end
  end
end