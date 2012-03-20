require "./sales_engine"
require "./merchant"
require "./item"
require "./invoice"

describe Merchant do
  let(:se) { SalesEngine.new }
  let(:merchant_1) { Merchant.new({ :id => 1 }) }
  let(:merchant_2) { Merchant.new({ :id => 2 }) }

  before(:each) do
    se.add_merchant_to_list(merchant_1)
    se.add_merchant_to_list(merchant_2)
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
      se.add_invoice_to_list(invoice_1)
      se.add_invoice_to_list(invoice_2)
      se.add_invoice_to_list(invoice_3)
      merchant_1.invoices(se).should == [invoice_2, invoice_3]
    end
  end

end