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

  describe "find_by_id()" do
    it "returns one item" do
      SalesEngine::Item.find_by_id("100").should be_a SalesEngine::Item
    end

    it "returns an item with the id given" do
      result = SalesEngine::Item.find_by_id("100")
      result.id.should == "100"
    end
  end

  describe "find_by_name()" do
    it "returns one item" do
      SalesEngine::Item.find_by_name("Item Necessitatibus Facilis").should be_a SalesEngine::Item
    end

    it "returns an item with the name given" do
      result = SalesEngine::Item.find_by_name("Item Necessitatibus Facilis")
      result.name.should == "Item Necessitatibus Facilis"
    end
  end

  describe "find_by_description()" do
    it "returns one item" do
      SalesEngine::Item.find_by_description("Omnis error accusantium est ea enim sint. Vero accusantium voluptatem natus et commodi deleniti. Autem soluta omnis in qui commodi. Qui corporis est ut blanditiis. Sit corrupti magnam sit dolores nostrum unde esse.").should be_a SalesEngine::Item
    end

    it "returns an item with the name given" do
      result = SalesEngine::Item.find_by_description("Omnis error accusantium est ea enim sint. Vero accusantium voluptatem natus et commodi deleniti. Autem soluta omnis in qui commodi. Qui corporis est ut blanditiis. Sit corrupti magnam sit dolores nostrum unde esse.")
      result.description.should == "Omnis error accusantium est ea enim sint. Vero accusantium voluptatem natus et commodi deleniti. Autem soluta omnis in qui commodi. Qui corporis est ut blanditiis. Sit corrupti magnam sit dolores nostrum unde esse."
    end
  end

  describe "find_by_unit_price()" do
    it "returns one item" do
      SalesEngine::Item.find_by_unit_price("16516").should be_a SalesEngine::Item
    end

    it "returns an item with the name given" do
      result = SalesEngine::Item.find_by_unit_price("16516")
      result.unit_price.should == "16516"
    end
  end

  describe "find_by_merchant_id()" do
    it "returns one item" do
      SalesEngine::Item.find_by_merchant_id("1").should be_a SalesEngine::Item
    end

    it "returns an item with the name given" do
      result = SalesEngine::Item.find_by_merchant_id("1")
      result.merchant_id.should == "1"
    end
  end

  describe "find_by_created_at()" do
    it "returns one item" do
      SalesEngine::Item.find_by_created_at("2012-02-26 20:56:50 UTC").should be_a SalesEngine::Item
    end

    it "returns an item with the date given" do
      result = SalesEngine::Item.find_by_created_at("2012-02-26 20:56:50 UTC")
      result.created_at.should == "2012-02-26 20:56:50 UTC"
    end
  end

  describe "find_by_updated_at()" do
    it "returns one item" do
      SalesEngine::Item.find_by_updated_at("2012-02-26 20:56:50 UTC").should be_a SalesEngine::Item
    end

    it "returns an item with the date given" do
      result = SalesEngine::Item.find_by_updated_at("2012-02-26 20:56:50 UTC")
      result.updated_at.should == "2012-02-26 20:56:50 UTC"
    end
  end

  describe ".find_all_by_id()" do
    it "returns an array of items" do
      SalesEngine::Item.find_all_by_id("100").all?{|i| i.is_a? SalesEngine::Item}.should == true
    end

    it "contains items related to the id given" do
      results = SalesEngine::Item.find_all_by_id("100")
      results.sample.id.should == "100"
    end
  end

  describe ".find_all_by_created_at()" do
    it "returns an array of items" do
      SalesEngine::Item.find_all_by_created_at("2012-02-26 20:56:50 UTC").all?{|i| i.is_a? SalesEngine::Item}.should == true
    end

    it "contains items related to the date given" do
      results = SalesEngine::Item.find_all_by_created_at("2012-02-26 20:56:50 UTC")
      results.sample.created_at.should == "2012-02-26 20:56:50 UTC"
    end
  end

  describe ".find_all_by_updated_at()" do
    it "returns an array of items" do
      SalesEngine::Item.find_all_by_updated_at("2012-02-26 20:56:50 UTC").all?{|i| i.is_a? SalesEngine::Item}.should == true
    end

    it "contains items related to the date given" do
      results = SalesEngine::Item.find_all_by_updated_at("2012-02-26 20:56:50 UTC")
      results.sample.created_at.should == "2012-02-26 20:56:50 UTC"
    end
  end

  describe ".find_all_by_name()" do
    it "returns an array of items" do
      SalesEngine::Item.find_all_by_name("Item Repellat Dolorum").all?{|i| i.is_a? SalesEngine::Item}.should == true
    end

    it "contains items related to the name given" do
      results = SalesEngine::Item.find_all_by_name("Item Repellat Dolorum")
      results.sample.name.should == "Item Repellat Dolorum"
    end
  end

  describe ".find_all_by_description()" do
    it "returns an array of items" do
      SalesEngine::Item.find_all_by_description("Nihil illo ut dolorem velit est. Est aut molestiae id optio. Minima nihil tenetur praesentium. Itaque aut libero necessitatibus et dolorem inventore.").all?{|i| i.is_a? SalesEngine::Item}.should == true
    end

    it "contains items related to the description given" do
      results = SalesEngine::Item.find_all_by_description("Nihil illo ut dolorem velit est. Est aut molestiae id optio. Minima nihil tenetur praesentium. Itaque aut libero necessitatibus et dolorem inventore.")
      results.sample.description.should == "Nihil illo ut dolorem velit est. Est aut molestiae id optio. Minima nihil tenetur praesentium. Itaque aut libero necessitatibus et dolorem inventore."
    end
  end

  describe ".find_all_by_unit_price()" do
    it "returns an array of items" do
      SalesEngine::Item.find_all_by_unit_price("80226").all?{|i| i.is_a? SalesEngine::Item}.should == true
    end

    it "contains items related to the description given" do
      results = SalesEngine::Item.find_all_by_unit_price("80226")
      results.sample.unit_price.should == "80226"
    end
  end

  describe ".find_all_by_merchant_id()" do
    it "returns an array of items" do
      SalesEngine::Item.find_all_by_merchant_id("1").all?{|i| i.is_a? SalesEngine::Item}.should == true
    end

    it "contains items related to the description given" do
      results = SalesEngine::Item.find_all_by_merchant_id("1")
      results.sample.merchant_id.should == "1"
    end
  end

end
