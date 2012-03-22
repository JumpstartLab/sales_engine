require './spec/spec_helper'

describe Item do
  let(:se) { Database.instance}
  let(:item_1) { Item.new({ :id => 1 }) }
  let(:item_2) { Item.new({ :id => 2 }) }

  before(:each) do
    se.clear_all_data
    se.add_to_list(item_1)
    se.add_to_list(item_2)
  end

  describe ".random" do
    let(:item_3) { Item.new({ :id => 3 }) }

    context "when items exist in the datastore" do
      it "returns a random Item record" do
        se.items.include?(Item.random).should be_true
      end
    end

    context "when there are no items in the datastore" do
      it "returns nil" do
        se.clear_all_data
        Item.random.should be_nil
      end
    end
  end

  describe ".find_by_id" do
    context "when items exist in the datastore" do
      it "returns the correct item record that matches the id" do
        Item.find_by_id(2).should == item_2
      end

      it "returns nothing if no item records match the id" do
        Item.find_by_id(100).should be_nil
      end
    end

    context "when there are no items in the datastore" do
      it "returns nothing" do
        se.clear_all_data
        Item.find_by_id(1).should be_nil
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
        Item.find_by_name('Sprocket').should == item_2
      end

      it "returns nothing if no item records match the name" do
        Item.find_by_name('junk').should be_nil
      end
    end

    context "when there are no items in the datastore" do
      it "returns nothing" do
        se.clear_all_data
        Item.find_by_name('Widget').should be_nil
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
        Item.find_by_description('sprocket for teleporter').should == item_2
      end

      it "returns nothing if no item records match the description" do
        Item.find_by_description('junk for scrap').should be_nil
      end
    end

    context "when there are no items in the datastore" do
      it "returns nothing" do
        se.clear_all_data
        Item.find_by_description('SPROCKET FOR TELEPORTER').should be_nil
      end
    end
  end

  describe ".find_by_unit_price" do
    context "when items exist in the datastore" do
      let(:item_3) { Item.new({ :id => 3 }) }

      before(:each) do
        item_1.unit_price = 5
        item_2.unit_price = 10
        item_3.unit_price = 5555
        se.add_to_list(item_3)
      end

      it "returns the correct item record that matches the unit price" do
        Item.find_by_unit_price(10).should == item_2
      end

      it "returns nothing if no item records match the unit price" do
        Item.find_by_unit_price(99).should be_nil
      end
    end

    context "when there are no items in the datastore" do
      it "returns nothing" do
        se.clear_all_data
        Item.find_by_unit_price(10).should be_nil
      end
    end
  end

  describe ".find_by_merchant_id" do
    context "when items exist in the datastore" do
      let(:item_3) { Item.new({ :id => 3 }) }

      before(:each) do
        item_1.merchant_id = 5
        item_2.merchant_id = 10
        item_3.merchant_id = 5555
        se.add_to_list(item_3)
      end

      it "returns the correct item record that matches the merchant id" do
        Item.find_by_merchant_id(10).should == item_2
      end

      it "returns nothing if no item records match the merchant id" do
        Item.find_by_merchant_id(99).should be_nil
      end
    end

    context "when there are no items in the datastore" do
      it "returns nothing" do
        se.clear_all_data
        Item.find_by_merchant_id(10).should be_nil
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
        Item.find_by_created_at("01/11/2012 13:00").should == item_2
      end

      it "returns nothing if no item records match the created_at time" do
        Item.find_by_created_at("01/11/1979 10:00").should be_nil
      end
    end

    context "when there are no items in the datastore" do
      it "returns nothing" do
        se.clear_all_data
        Item.find_by_created_at("01/11/2012 13:00").should be_nil
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
        Item.find_by_updated_at("01/11/2012 13:00").should == item_2
      end

      it "returns nothing if no item records match the updated_at time" do
        Item.find_by_updated_at("01/11/1979 10:00").should be_nil
      end
    end

    context "when there are no items in the datastore" do
      it "returns nothing" do
        se.clear_all_data
        Item.find_by_updated_at("01/11/2012 13:00").should be_nil
      end
    end
  end
  
  describe ".find_all_by_id" do
    context "when items exist in the datastore" do
      it "returns the correct item records that matches the id" do
        Item.find_all_by_id(2).should == [item_2]
      end

      it "returns nothing if no item records match the id" do
        Item.find_all_by_id(100).should == []
      end
    end

    context "when there are no items in the datastore" do
      it "returns nothing" do
        se.clear_all_data
        Item.find_all_by_id(1).should == []
      end
    end
  end

    describe ".find_all_by_name" do
    context "when items exist in the datastore" do
      let(:item_3) { Item.new({ :id => 3 }) }

      before(:each) do
        item_1.name = "Widget"
        item_2.name = "sprocket"
        item_3.name = "widget"
        se.add_to_list(item_3)
      end

      it "returns the correct item records that matches the name" do
        Item.find_all_by_name("Widget").should == [item_1, item_3]
      end

      it "returns nothing if no item records match the name" do
        Item.find_all_by_name('junk').should == []
      end
    end

    context "when there are no items in the datastore" do
      it "returns nothing" do
        se.clear_all_data
        Item.find_all_by_name('Widget').should == []
      end
    end
  end

  describe ".find_all_by_description" do
    context "when items exist in the datastore" do
      let(:item_3) { Item.new({ :id => 3 }) }
      let(:item_4) { Item.new({ :id => 4 }) }

      before(:each) do
        item_1.description = "one inch wood nail"
        item_2.description = "Two Inch Wood Nail"
        item_3.description = "two inch wood nail"
        item_4.description = "five inch wood nail"
        se.add_to_list(item_3)
        se.add_to_list(item_4)
      end

      it "returns the correct item records that match the description" do
        Item.find_all_by_description('TWO INCH WOOD NAIL').should == [item_2, item_3]
      end

      it "returns nothing if no item records match the description" do
        Item.find_all_by_description('junk for scrap').should == []
      end
    end

    context "when there are no items in the datastore" do
      it "returns nothing" do
        se.clear_all_data
        Item.find_all_by_description('two inch wood nail').should == []
      end
    end
  end

  describe ".find_all_by_unit_price" do
    context "when items exist in the datastore" do
      let(:item_3) { Item.new({ :id => 3 }) }

      before(:each) do
        item_1.unit_price = 10
        item_2.unit_price = 10
        item_3.unit_price = 5555
        se.add_to_list(item_3)
      end

      it "returns the correct item records that match the unit price" do
        Item.find_all_by_unit_price(10).should == [item_1, item_2]
      end

      it "returns nothing if no item records match the unit price" do
        Item.find_all_by_unit_price(99).should == []
      end
    end

    context "when there are no items in the datastore" do
      it "returns nothing" do
        se.clear_all_data
        Item.find_all_by_unit_price(10).should == []
      end
    end
  end

  describe ".find_all_by_merchant_id" do
    context "when items exist in the datastore" do
      let(:item_3) { Item.new({ :id => 3 }) }

      before(:each) do
        item_1.merchant_id = 5
        item_2.merchant_id = 10
        item_3.merchant_id = 10
        se.add_to_list(item_3)
      end

      it "returns the correct item records that match the merchant id" do
        Item.find_all_by_merchant_id(10).should == [item_2, item_3]
      end

      it "returns nothing if no item records match the merchant id" do
        Item.find_all_by_merchant_id(99).should == []
      end
    end

    context "when there are no items in the datastore" do
      it "returns nothing" do
        se.clear_all_data
        Item.find_all_by_merchant_id(10).should == []
      end
    end
  end

  describe ".find_all_by_created_at" do
    context "when items exist in the datastore" do
      let(:item_3) { Item.new({ :id => 3 }) }

      before(:each) do
        item_1.created_at = "03/01/2012 12:00"
        item_2.created_at = "01/11/2012 13:00"
        item_3.created_at = "01/11/2012 13:00"
        se.add_to_list(item_3)
      end

      it "returns the correct item records that matches the created_at time" do
        Item.find_all_by_created_at("01/11/2012 13:00").should == [item_2, item_3]
      end

      it "returns nothing if no item records match the created_at time" do
        Item.find_all_by_created_at("01/11/1979 10:00").should == []
      end
    end

    context "when there are no items in the datastore" do
      it "returns nothing" do
        se.clear_all_data
        Item.find_all_by_created_at("01/11/2012 13:00").should == []
      end
    end
  end

  describe ".find_by_updated_at" do
      context "when items exist in the datastore" do
      let(:item_3) { Item.new({ :id => 3 }) }
      before(:each) do
        item_1.updated_at = "03/01/2012 12:00"
        item_2.updated_at = "01/11/2012 13:00"
        item_3.updated_at = "01/11/2012 13:00"
        se.add_to_list(item_3)
      end

      it "returns the correct item records that matches the updated_at time" do
        Item.find_all_by_updated_at("01/11/2012 13:00").should == [item_2, item_3]
      end

      it "returns nothing if no item records match the updated_at time" do
        Item.find_all_by_updated_at("01/11/1979 10:00").should == []
      end
    end

    context "when there are no items in the datastore" do
      it "returns nothing" do
        se.clear_all_data
        Item.find_all_by_updated_at("01/11/2012 13:00").should == []
      end
    end
  end

  describe "#invoice_items" do
    context "when invoice items exist in the datastore" do
      let(:invoice_item_1) { InvoiceItem.new({:id => 1, :item_id => item_1.id }) }
      let(:invoice_item_2) { InvoiceItem.new({:id => 2, :item_id => item_1.id }) }
      let(:invoice_item_3) { InvoiceItem.new({:id => 3, :item_id => item_2.id }) }
      let(:invoice_item_4) { InvoiceItem.new({:id => 4, :item_id => item_1.id }) }
      let(:item_3) { Item.new({ :id => 3 }) }

      before(:each) do
        se.add_to_list(invoice_item_1)
        se.add_to_list(invoice_item_2)
        se.add_to_list(invoice_item_3)
        se.add_to_list(invoice_item_4)
        se.add_to_list(item_3)
      end

      it "returns a collection of InvoiceItems associated with this object" do
        item_1.invoice_items.should == [invoice_item_1, invoice_item_2, invoice_item_4]
      end

      it "returns nothing if no invoice items are associated with the item id" do
        item_3.invoice_items.should == []
      end
    end
  end
end