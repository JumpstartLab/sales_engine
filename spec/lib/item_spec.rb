require 'spec_helper.rb'

describe SalesEngine::Item do

  let(:inv_item_one){ SalesEngine::InvoiceItem.new( :unit_price => "10", :quantity => "3",
                                                    :invoice_id => "1", :item_id => "1" ) }
  let(:inv_item_two){ SalesEngine::InvoiceItem.new( :unit_price => "1", :quantity => "3",
                                                    :invoice_id => "2", :item_id => "2" ) } 
  let(:inv_item_three){ SalesEngine::InvoiceItem.new( :unit_price => "10", :quantity => "3",
                                                    :invoice_id => "3", :item_id => "1") }
  let(:item_one){ SalesEngine::Item.new( :id => "1", :merchant_id => "1" ) }
  let(:item_two){ SalesEngine::Item.new( :id => "2", :merchant_id => "2" )}
  let(:merchant_one){ SalesEngine::Merchant.new( :id => "1" )}
  let(:merchant_two){ SalesEngine::Merchant.new( :id => "2" )}

  describe "#invoice_items" do
    it "returns a collection of invoice_items associated with the item instance" do
      SalesEngine::Database.instance.invoice_item_list = [ inv_item_one, inv_item_two, inv_item_three ]
      item_one.invoice_items.should == [ inv_item_one, inv_item_three ]
    end

    context "when an invoice has an invalid invoice id" do
      it "returns empty array" do
        SalesEngine::Database.instance.invoice_item_list = [ inv_item_two ]
        item_one.invoice_items.should be_empty
      end
    end
  end

  # describe "#merchant" do
  #   it "returns an instance of merchant associated with the instance" do
  #     SalesEngine::Database.instance.merchant_list = [ merchant_one, merchant_two ]
  #     item_one.merchant.should == merchant_one

  #     context "when an invoice has an invalid item id" do
  #       it "returns nil" do
  #         SalesEngine::Database.instance.merchant_list = [ merchant_two ]
  #         item_one.merchant.should be_nil
  #       end
  #     end
  #   end
  # end

  # describe ".most_revenue(x)" do
  #   it "returns the top x items ranked by total revenue generated" do
  #     SalesEngine::Database.instance.invoice_item_list = [ inv_item_one, inv_item_two, inv_item_three ]
  #     SalesEngine::Database.instance.item_list = [ item_two, item_one ]
  #     Item.most_revenue(2).should == [ item_one, item_two ]
  #   end

  #   context "when there are no items" do
  #     it "returns nil" do
  #       SalesEngine::Database.instance.item_list = [ ]
  #       Item.most_revenue(2).should == nil
  #     end
  #   end

  #   context "when there are no invoice_items" do
  #     it "returns nil" do
  #       SalesEngine::Database.instance.invoice_item_list = [ ]
  #       Item.most_revenue(2).should == nil
  #     end
  #   end
  # end

  # describe ".most_items(x)" do
  #   it "returns the top x items ranked by total numbers sold" do
  #     SalesEngine::Database.instance.invoice_item_list = [ inv_item_one, inv_item_two, inv_item_three ]
  #     SalesEngine::Database.instance.item_list = [ item_two, item_one ]
  #     Item.most_items(2).should == [ item_one, item_two ]
  #   end

  #   context "when there are no items" do
  #     it "returns nil" do
  #       SalesEngine::Database.instance.item_list = [ ]
  #       Item.most_items(2).should == nil
  #     end
  #   end

  #   context "when there are no invoice_items" do
  #     it "returns nil" do
  #       SalesEngine::Database.instance.invoice_item_list = [ ]
  #       Item.most_items(2).should == nil
  #     end
  #   end
  # end

end