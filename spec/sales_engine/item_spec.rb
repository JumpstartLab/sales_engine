require 'spec_helper'

describe SalesEngine::Item do

  let (:test_item){ Fabricate(:item) }

  describe "#invoice_items" do
    context "returns a collection of invoice items" do

      it "contains things which are only invoice items" do
        test_item.invoice_items.all?{|i| i.is_a? SalesEngine::InvoiceItem}.should == true
      end

      it "contains invoice items associated with only this item" do
        test_item.invoice_items.all? {|i|
          i.item_id == test_item.id}.should == true
      end
    end
  end

  describe "#merchant" do
    context "returns a merchant" do
      it "is a merchant" do
        test_item.merchant.should be_a SalesEngine::Merchant
      end

      it "is associated with this item" do
        test_item.merchant.id.should == test_item.merchant_id
      end
    end
  end

  describe ".random" do
    it "is an item" do
      SalesEngine::Item.random.should be_an SalesEngine::Item
    end
  end

  describe "#best_day" do
    it "returns a string of a date" do
      test_item.best_day.should =~ /[0-9][0-9][0-9][0-9][-][0-1][0-9]-[0-3][0-9]/
    end

    it "the date has the most sales for this item" do
      pending
    end
  end

  test_item_1 = Fabricate(:item,
                          :id => "1",
                          :name => "Item Name",
                          :description => "Item description",
                          :unit_price => "2930",
                          :merchant_id => "3",
                          :created_at => "3/31/1985",
                          :updated_at => "3/31/1985")
  test_item_2 = Fabricate(:item,
                          :id => "2",
                          :name => "Item Name",
                          :description => "Item description",
                          :unit_price => "2930",
                          :merchant_id => "3",
                          :created_at => "3/31/1985",
                          :updated_at => "3/31/1985")
  test_item_3 = Fabricate(:item,
                          :id => "3",
                          :name => "Item Name",
                          :description => "Item description",
                          :unit_price => "2930",
                          :merchant_id => "3",
                          :created_at => "3/31/1985",
                          :updated_at => "3/31/1985")
  test_items = [ test_item_1, test_item_2, test_item_3 ]

  describe "find_by_id()" do
    it "returns one item" do
      SalesEngine::Database.instance.stub(:items).and_return (test_items)
      SalesEngine::Item.find_by_id("2").should be_a SalesEngine::Item
    end

    it "returns an item with the id given" do
      SalesEngine::Database.instance.stub(:items).and_return (test_items)
      result = SalesEngine::Item.find_by_id("2")
      result.id.should == "2"
    end
  end

  describe "find_by_name()" do
    it "returns one item" do
      SalesEngine::Database.instance.stub(:items).and_return (test_items)
      SalesEngine::Item.find_by_name("Item Name").should be_a SalesEngine::Item
    end

    it "returns an item with the name given" do
      SalesEngine::Database.instance.stub(:items).and_return (test_items)
      result = SalesEngine::Item.find_by_name("Item Name")
      result.name.should == "Item Name"
    end
  end

  describe "find_by_description()" do
    it "returns one item" do
      SalesEngine::Database.instance.stub(:items).and_return (test_items)
      SalesEngine::Item.find_by_description("Item description").should be_a SalesEngine::Item
    end

    it "returns an item with the name given" do
      SalesEngine::Database.instance.stub(:items).and_return (test_items)
      result = SalesEngine::Item.find_by_description("Item description")
      result.description.should == "Item description"
    end
  end

  describe "find_by_unit_price()" do
    it "returns one item" do
      SalesEngine::Database.instance.stub(:items).and_return (test_items)
      SalesEngine::Item.find_by_unit_price("2930").should be_a SalesEngine::Item
    end

    it "returns an item with the name given" do
      SalesEngine::Database.instance.stub(:items).and_return (test_items)
      result = SalesEngine::Item.find_by_unit_price("2930")
      result.unit_price.should == "2930"
    end
  end

  describe "find_by_merchant_id()" do
    it "returns one item" do
      SalesEngine::Database.instance.stub(:items).and_return (test_items)
      SalesEngine::Item.find_by_merchant_id("3").should be_a SalesEngine::Item
    end

    it "returns an item with the name given" do
      SalesEngine::Database.instance.stub(:items).and_return (test_items)
      result = SalesEngine::Item.find_by_merchant_id("3")
      result.merchant_id.should == "3"
    end
  end

  describe "find_by_created_at()" do
    it "returns one item" do
      SalesEngine::Database.instance.stub(:items).and_return (test_items)
      SalesEngine::Item.find_by_created_at("3/31/1985").should be_a SalesEngine::Item
    end

    it "returns an item with the date given" do
      SalesEngine::Database.instance.stub(:items).and_return (test_items)
      result = SalesEngine::Item.find_by_created_at("3/31/1985")
      result.created_at.should == "3/31/1985"
    end
  end

  describe "find_by_updated_at()" do
    it "returns one item" do
      SalesEngine::Database.instance.stub(:items).and_return (test_items)
      SalesEngine::Item.find_by_updated_at("3/31/1985").should be_a SalesEngine::Item
    end

    it "returns an item with the date given" do
      SalesEngine::Database.instance.stub(:items).and_return (test_items)
      result = SalesEngine::Item.find_by_updated_at("3/31/1985")
      result.updated_at.should == "3/31/1985"
    end
  end

  describe ".find_all_by_id()" do
    it "returns an array of items" do
      SalesEngine::Database.instance.stub(:items).and_return (test_items)
      SalesEngine::Item.find_all_by_id("3").all?{|i| i.is_a? SalesEngine::Item}.should == true
    end

    it "contains items related to the id given" do
      SalesEngine::Database.instance.stub(:items).and_return (test_items)
      results = SalesEngine::Item.find_all_by_id("3")
      results.sample.id.should == "3"
    end
  end

  describe ".find_all_by_created_at()" do
    it "returns an array of items" do
      SalesEngine::Database.instance.stub(:items).and_return (test_items)
      SalesEngine::Item.find_all_by_created_at("3/31/1985").all?{|i| i.is_a? SalesEngine::Item}.should == true
    end

    it "contains items related to the date given" do
      SalesEngine::Database.instance.stub(:items).and_return (test_items)
      results = SalesEngine::Item.find_all_by_created_at("3/31/1985")
      results.sample.created_at.should == "3/31/1985"
    end
  end

  describe ".find_all_by_updated_at()" do
    it "returns an array of items" do
      SalesEngine::Database.instance.stub(:items).and_return (test_items)
      SalesEngine::Item.find_all_by_updated_at("3/31/1985").all?{|i| i.is_a? SalesEngine::Item}.should == true
    end

    it "contains items related to the date given" do
      SalesEngine::Database.instance.stub(:items).and_return (test_items)
      results = SalesEngine::Item.find_all_by_updated_at("3/31/1985")
      results.sample.created_at.should == "3/31/1985"
    end
  end

  describe ".find_all_by_name()" do
    it "returns an array of items" do
      SalesEngine::Database.instance.stub(:items).and_return (test_items)
      SalesEngine::Item.find_all_by_name("Item Name").all?{|i| i.is_a? SalesEngine::Item}.should == true
    end

    it "contains items related to the name given" do
      SalesEngine::Database.instance.stub(:items).and_return (test_items)
      results = SalesEngine::Item.find_all_by_name("Item Name")
      results.sample.name.should == "Item Name"
    end
  end

  describe ".find_all_by_description()" do
    it "returns an array of items" do
      SalesEngine::Database.instance.stub(:items).and_return (test_items)
      SalesEngine::Item.find_all_by_description("Item description").all?{|i| i.is_a? SalesEngine::Item}.should == true
    end

    it "contains items related to the description given" do
      SalesEngine::Database.instance.stub(:items).and_return (test_items)
      results = SalesEngine::Item.find_all_by_description("Item description")
      results.sample.description.should == "Item description"
    end
  end

  describe ".find_all_by_unit_price()" do
    it "returns an array of items" do
      SalesEngine::Database.instance.stub(:items).and_return (test_items)
      SalesEngine::Item.find_all_by_unit_price("2930").all?{|i| i.is_a? SalesEngine::Item}.should == true
    end

    it "contains items related to the description given" do
      SalesEngine::Database.instance.stub(:items).and_return (test_items)
      results = SalesEngine::Item.find_all_by_unit_price("2930")
      results.sample.unit_price.should == "2930"
    end
  end

  describe ".find_all_by_merchant_id()" do
    it "returns an array of items" do
      SalesEngine::Database.instance.stub(:items).and_return (test_items)
      SalesEngine::Item.find_all_by_merchant_id("3").all?{|i| i.is_a? SalesEngine::Item}.should == true
    end

    it "contains items related to the description given" do
      SalesEngine::Database.instance.stub(:items).and_return (test_items)
      results = SalesEngine::Item.find_all_by_merchant_id("3")
      results.sample.merchant_id.should == "3"
    end
  end

end
