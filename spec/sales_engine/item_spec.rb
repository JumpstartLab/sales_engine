require 'spec_helper'

describe SalesEngine::Item do
  let(:se) { SalesEngine::Database.instance }
  let(:item_1)        { Fabricate(:item) }
  let(:item_2)        { Fabricate(:item) }
  let(:item_3)        { Fabricate(:item) }
  let(:item_4)        { Fabricate(:item) }
  let(:item_5)        { Fabricate(:item) }
  let(:item_6)        { Fabricate(:item) }
  let(:item_7)        { Fabricate(:item) }
  let(:item_8)        { Fabricate(:item) }
  let(:invoice_1)     { Fabricate(:invoice)}
  let(:transaction_1) { Fabricate(:transaction)}
  let(:invoice_item_1) { Fabricate(:invoice_item, :item_id => item_1.id, :unit_price => 1, :invoice_id => invoice_1.id) }
  let(:invoice_item_2) { Fabricate(:invoice_item, :item_id => item_2.id, :unit_price => 1, :invoice_id => invoice_1.id) }
  let(:invoice_item_3) { Fabricate(:invoice_item, :item_id => item_3.id, :unit_price => 1, :invoice_id => invoice_1.id) }
  let(:invoice_item_4) { Fabricate(:invoice_item, :item_id => item_4.id, :unit_price => 5, :invoice_id => invoice_1.id) }
  let(:invoice_item_5) { Fabricate(:invoice_item, :item_id => item_5.id, :unit_price => 1, :invoice_id => invoice_1.id) }
  let(:invoice_item_6) { Fabricate(:invoice_item, :item_id => item_6.id, :unit_price => 2, :invoice_id => invoice_1.id) }
  let(:invoice_item_7) { Fabricate(:invoice_item, :item_id => item_7.id, :unit_price => 2, :invoice_id => invoice_1.id) }
  let(:invoice_item_8) { Fabricate(:invoice_item, :item_id => item_1.id, :unit_price => 3, :invoice_id => invoice_1.id) }
  let(:invoice_item_9) { Fabricate(:invoice_item, :item_id => item_2.id, :unit_price => 20, :invoice_id => invoice_1.id) }
  let(:invoice_item_10) { Fabricate(:invoice_item, :item_id => item_3.id, :unit_price => 1, :invoice_id => invoice_1.id) }
  let(:invoice_item_11) { Fabricate(:invoice_item, :item_id => item_1.id, :unit_price => 4, :invoice_id => invoice_1.id) }
  let(:merchant_1) { Fabricate(:merchant) }
  let(:merchant_2) { Fabricate(:merchant) }

  before(:each) do
    se.clear_all_data
    se.add_to_list(item_1)
    se.add_to_list(item_2)
    se.add_to_list(item_3)
    se.add_to_list(item_4)
    se.add_to_list(item_5)
    se.add_to_list(item_6)
    se.add_to_list(item_7) 
    se.add_to_list(item_8)
    se.add_to_list(item_8)
    se.add_to_list(invoice_1)
    se.add_to_list(transaction_1)
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
    se.add_to_list(merchant_1)
    se.add_to_list(merchant_2)
  end

  # # describe "#best_day" do
  # #   before(:each) do
  # #     invoice_item_1.created_at = "2012-03-14 20:56:56 UTC"
  # #     invoice_item_8.created_at = "2012-03-14 20:00:51 UTC"
  # #     invoice_item_11.created_at = "2012-02-01 16:16:41 UTC"  
  # #   end

  #   it "returns the date with the most sales for the given item" do
  #     item_1.best_day.should == Date.parse("2012-03-14")
  #   end
  # end

  describe ".random" do
    context "when items exist in the datastore" do
      it "returns a random Item record" do
        se.items.include?(SalesEngine::Item.random).should be_true
      end
    end

    context "when there are no items in the datastore" do
      it "returns nil" do
        se.clear_all_data
        SalesEngine::Item.random.should be_nil
      end
    end
  end

  describe ".find_by_id" do
    context "when items exist in the datastore" do
      it "returns the correct item record that matches the id" do
        SalesEngine::Item.find_by_id(item_2.id).should == item_2
      end

      it "returns nothing if no item records match the id" do
        SalesEngine::Item.find_by_id(100).should be_nil
      end
    end

    context "when there are no items in the datastore" do
      it "returns nothing" do
        se.clear_all_data
        SalesEngine::Item.find_by_id(item_1.id).should be_nil
      end
    end
  end
  
  describe ".find_by_name" do
    context "when items exist in the datastore" do
      before(:each) do
        item_1.name = "Widget"
        item_2.name = "sprocket"
      end

      it "returns the correct item record that matches the name" do
        SalesEngine::Item.find_by_name('Sprocket').should == item_2
      end

      it "returns nothing if no item records match the name" do
        SalesEngine::Item.find_by_name('junk').should be_nil
      end
    end

    context "when there are no items in the datastore" do
      it "returns nothing" do
        se.clear_all_data
        SalesEngine::Item.find_by_name('Widget').should be_nil
      end
    end
  end

  describe ".find_by_description" do
    context "when items exist in the datastore" do
      before(:each) do
        item_1.description = "Widget for spaceship"
        item_2.description = "SPROCKET FOR TELEPORTER"
      end

      it "returns the correct item record that matches the description" do
        SalesEngine::Item.find_by_description('sprocket for teleporter').should == item_2
      end

      it "returns nothing if no item records match the description" do
        SalesEngine::Item.find_by_description('junk for scrap').should be_nil
      end
    end

    context "when there are no items in the datastore" do
      it "returns nothing" do
        se.clear_all_data
        SalesEngine::Item.find_by_description('SPROCKET FOR TELEPORTER').should be_nil
      end
    end
  end

  describe ".find_by_unit_price" do
    context "when items exist in the datastore" do
      before(:each) do
        item_1.unit_price = BigDecimal.new("5")
        item_2.unit_price = BigDecimal.new("10")
        item_3.unit_price = BigDecimal.new("5555")
      end

      it "returns the correct item record that matches the unit price" do
        value = BigDecimal.new("10")
        SalesEngine::Item.find_by_unit_price(value).should == item_2
      end

      it "returns nothing if no item records match the unit price" do
        value = BigDecimal.new("9999")
        SalesEngine::Item.find_by_unit_price(value).should be_nil
      end
    end

    context "when there are no items in the datastore" do
      it "returns nothing" do
        se.clear_all_data
        value = BigDecimal.new("10")
        SalesEngine::Item.find_by_unit_price(value).should be_nil
      end
    end
  end

  describe ".find_by_merchant_id" do
    context "when items exist in the datastore" do
      before(:each) do
        item_1.merchant_id = 5
        item_2.merchant_id = 10
        item_3.merchant_id = 5555
      end

      it "returns the correct item record that matches the merchant id" do
        SalesEngine::Item.find_by_merchant_id(10).should == item_2
      end

      it "returns nothing if no item records match the merchant id" do
        SalesEngine::Item.find_by_merchant_id(99).should be_nil
      end
    end

    context "when there are no items in the datastore" do
      it "returns nothing" do
        se.clear_all_data
        SalesEngine::Item.find_by_merchant_id(10).should be_nil
      end
    end
  end

  describe ".find_by_created_at" do
    context "when items exist in the datastore" do
      before(:each) do
        item_1.created_at = "03/01/2012 12:00"
        item_2.created_at = "01/11/2012 13:00"
      end

      it "returns the correct item record that matches the created_at time" do
        SalesEngine::Item.find_by_created_at("01/11/2012 13:00").should == item_2
      end

      it "returns nothing if no item records match the created_at time" do
        SalesEngine::Item.find_by_created_at("01/11/1979 10:00").should be_nil
      end
    end

    context "when there are no items in the datastore" do
      it "returns nothing" do
        se.clear_all_data
        SalesEngine::Item.find_by_created_at("01/11/2012 13:00").should be_nil
      end
    end
  end
  
  describe ".find_by_updated_at" do
      context "when items exist in the datastore" do
      before(:each) do
        item_1.updated_at = "03/01/2012 12:00"
        item_2.updated_at = "01/11/2012 13:00"
      end

      it "returns the correct item record that matches the updated_at time" do
        SalesEngine::Item.find_by_updated_at("01/11/2012 13:00").should == item_2
      end

      it "returns nothing if no item records match the updated_at time" do
        SalesEngine::Item.find_by_updated_at("01/11/1979 10:00").should be_nil
      end
    end

    context "when there are no items in the datastore" do
      it "returns nothing" do
        se.clear_all_data
        SalesEngine::Item.find_by_updated_at("01/11/2012 13:00").should be_nil
      end
    end
  end
  
  describe ".find_all_by_id" do
    context "when items exist in the datastore" do
      it "returns the correct item records that matches the id" do
        SalesEngine::Item.find_all_by_id(item_2.id).should == [item_2]
      end

      it "returns nothing if no item records match the id" do
        SalesEngine::Item.find_all_by_id(100).should == []
      end
    end

    context "when there are no items in the datastore" do
      it "returns nothing" do
        se.clear_all_data
        SalesEngine::Item.find_all_by_id(item_1.id).should == []
      end
    end
  end

    describe ".find_all_by_name" do
    context "when items exist in the datastore" do
      before(:each) do
        item_1.name = "Widget"
        item_2.name = "sprocket"
        item_3.name = "widget"
      end

      it "returns the correct item records that matches the name" do
        SalesEngine::Item.find_all_by_name("Widget").should == [item_1, item_3]
      end

      it "returns nothing if no item records match the name" do
        SalesEngine::Item.find_all_by_name('junk').should == []
      end
    end

    context "when there are no items in the datastore" do
      it "returns nothing" do
        se.clear_all_data
        SalesEngine::Item.find_all_by_name('Widget').should == []
      end
    end
  end

  describe ".find_all_by_description" do
    context "when items exist in the datastore" do
      before(:each) do
        item_1.description = "one inch wood nail"
        item_2.description = "Two Inch Wood Nail"
        item_3.description = "two inch wood nail"
        item_4.description = "five inch wood nail"
      end

      it "returns the correct item records that match the description" do
        SalesEngine::Item.find_all_by_description('TWO INCH WOOD NAIL').should == [item_2, item_3]
      end

      it "returns nothing if no item records match the description" do
        SalesEngine::Item.find_all_by_description('junk for scrap').should == []
      end
    end

    context "when there are no items in the datastore" do
      it "returns nothing" do
        se.clear_all_data
        SalesEngine::Item.find_all_by_description('two inch wood nail').should == []
      end
    end
  end

  describe ".find_all_by_unit_price" do
    context "when items exist in the datastore" do
      before(:each) do
        item_1.unit_price = 10
        item_2.unit_price = 10
        item_3.unit_price = 5555
      end

      it "returns the correct item records that match the unit price" do
        SalesEngine::Item.find_all_by_unit_price(10).should == [item_1, item_2]
      end

      it "returns nothing if no item records match the unit price" do
        SalesEngine::Item.find_all_by_unit_price(99).should == []
      end
    end

    context "when there are no items in the datastore" do
      it "returns nothing" do
        se.clear_all_data
        SalesEngine::Item.find_all_by_unit_price(10).should == []
      end
    end
  end

  describe ".find_all_by_merchant_id" do
    context "when items exist in the datastore" do
      before(:each) do
        item_1.merchant_id = 5
        item_2.merchant_id = 10
        item_3.merchant_id = 10
      end

      it "returns the correct item records that match the merchant id" do
        SalesEngine::Item.find_all_by_merchant_id(10).should == [item_2, item_3]
      end

      it "returns nothing if no item records match the merchant id" do
        SalesEngine::Item.find_all_by_merchant_id(99).should == []
      end
    end

    context "when there are no items in the datastore" do
      it "returns nothing" do
        se.clear_all_data
        SalesEngine::Item.find_all_by_merchant_id(10).should == []
      end
    end
  end

  describe ".find_all_by_created_at" do
    context "when items exist in the datastore" do
      before(:each) do
        item_1.created_at = "03/01/2012 12:00"
        item_2.created_at = "01/11/2012 13:00"
        item_3.created_at = "01/11/2012 13:00"
      end

      it "returns the correct item records that matches the created_at time" do
        SalesEngine::Item.find_all_by_created_at("01/11/2012 13:00").should == [item_2, item_3]
      end

      it "returns nothing if no item records match the created_at time" do
        SalesEngine::Item.find_all_by_created_at("01/11/1979 10:00").should == []
      end
    end

    context "when there are no items in the datastore" do
      it "returns nothing" do
        se.clear_all_data
        SalesEngine::Item.find_all_by_created_at("01/11/2012 13:00").should == []
      end
    end
  end

  describe ".find_by_updated_at" do
      context "when items exist in the datastore" do
      before(:each) do
        item_1.updated_at = "03/01/2012 12:00"
        item_2.updated_at = "01/11/2012 13:00"
        item_3.updated_at = "01/11/2012 13:00"
      end

      it "returns the correct item records that matches the updated_at time" do
        SalesEngine::Item.find_all_by_updated_at("01/11/2012 13:00").should == [item_2, item_3]
      end

      it "returns nothing if no item records match the updated_at time" do
        SalesEngine::Item.find_all_by_updated_at("01/11/1979 10:00").should == []
      end
    end

    context "when there are no items in the datastore" do
      it "returns nothing" do
        se.clear_all_data
        SalesEngine::Item.find_all_by_updated_at("01/11/2012 13:00").should == []
      end
    end
  end

  describe "#invoice_items" do
    context "when invoice items exist in the datastore" do
      it "returns a collection of InvoiceItems associated with this object" do
        item_2.invoice_items.should == [invoice_item_2, invoice_item_9]
      end

      it "returns nothing if no invoice items are associated with the item id" do
        item_8.invoice_items.should == []
      end
    end
  end

  describe "#merchant" do
    context "when merchants exist in the datastore" do
      before(:each) do
        item_1.merchant_id = merchant_2.id
        item_2.merchant_id = merchant_1.id
      end

      it "returns an instance of Merchant associated with this object" do
        item_1.merchant.should == merchant_2
      end
    end
  end

  describe ".most_revenue" do
    it "returns the top x item instances ranked by total revenue" do
      SalesEngine::Item.most_revenue(3).should == [item_2, item_1, item_4]
    end
  end

  describe ".most_items" do
    it "returns the top x item instances ranked by total number sold" do
      SalesEngine::Item.most_items(2) == [item_1, item_2]
    end
  end

  describe "#total" do
    it "returns the total revenue for an item" do
      item_1.total.should == 8
    end
  end
end