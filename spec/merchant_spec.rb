require './spec/spec_helper'

describe Merchant do
  let(:se) { SalesEngine.instance}
  let(:merchant_1) { Merchant.new({ :id => 1 }) }
  let(:merchant_2) { Merchant.new({ :id => 2 }) }

  before(:each) do
    se.clear_all_data
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
      merchant_1.items.should == [item_1, item_2]
    end

    it "returns an empty array if no items are associated with the merchant" do
      merchant_1.items.should == []
    end
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
      merchant_1.invoices.should == [invoice_2, invoice_3]
    end

    it "returns an empty array if no invoices are associated with the merchant" do
      merchant_1.invoices.should == []
    end
  end

  describe ".random" do
    let(:merchant_3) { Merchant.new({ :id => 3 }) }

    context "when merchants exist in the datastore" do
      it "returns a random Merchant record" do
        se.merchants.include?(Merchant.random).should be_true
      end
    end
  end
end