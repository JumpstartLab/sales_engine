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
end
