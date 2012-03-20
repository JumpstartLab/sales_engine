require './sales_engine'
require './merchant'

describe SalesEngine do
  describe "#load_merchants_data" do
    it "reads in merchant data from a file & stores the result as a merchant master list" do
      se = SalesEngine.new
      se.load_merchants_data('./test/data/merchants.csv')
      se.merchants.count.should == 3
    end
  end

  describe "#load_items_data" do
    it "reads in item data from a file & stores the result as an item master list" do
      se = SalesEngine.new
      se.load_items_data('./test/data/items.csv')
      se.items.count.should == 2
    end
  end

  describe "#add_merchant_to_list" do
    it "allows you to add a new merchant object to the master merchant list" do
      se = SalesEngine.new
      se.add_merchant_to_list(Merchant.new)
      se.merchants.count.should == 1
    end
  end

  describe "#add_item_to_list" do
    it "allows you to add a new item object to the master item list" do
      se = SalesEngine.new
      se.add_item_to_list(Item.new)
      se.items.count.should == 1
    end
  end
end