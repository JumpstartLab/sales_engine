require "spec_helper"

module SalesEngine
  class ItemRecordTest
    extend ItemRecord
  end

  describe "#items" do
    it "returns all items" do
      ItemRecordTest.items.length.should == 2415
    end
  end

  describe ".most_items(x)" do
      context "when number of items is less than X" do
        it "returns an array of all merchants" do
        items = Item.most_items(2)
        items.length.should == 2
        items[1].name.should == "Item Omnis Doloremque"
      end
    end
  end

  describe ".most_revenue(x)" do
      context "when number of items is less than X" do
        it "returns an array of all merchants" do
        items = Item.most_revenue(2)
        items.length.should == 2
        items[1].name.should == "Item Quam Perferendis"
      end
    end
  end
end
