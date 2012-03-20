require "./sales_engine"
require "./merchant"
require "./item"

describe Merchant do
  let(:se) { SalesEngine.new }

  describe "#items" do
    it "returns items associated with the merchant if items exists" do
      merchant_1 = Merchant.new({ :id => 1 })
      merchant_2 = Merchant.new({ :id => 2 })
      se.add_merchant_to_list(merchant_1)
      se.add_merchant_to_list(merchant_2)
      item_1 = Item.new({ :id => 1, :merchant_id => nil })
      item_2 = item_1.clone
      item_2.id = 2
      item_3 = item_1.clone
      item_3.id = 3
      item_1.merchant_id = 1
      item_2.merchant_id = 1
      item_3.merchant_id = 2
      se.add_item_to_list(item_1)
      se.add_item_to_list(item_2)
      se.add_item_to_list(item_3)
      merchant_1.items(se).should == [item_1, item_2]
    end

    # it "returns an empty array if no items are associated with the merchant" do
    #   # create a merchant
    #   # call merchant.items
    #   # make sure an empty array is returned
    #   pending
    # end
  end
end