require 'spec_helper.rb'

describe SalesEngine::InvoiceItem do

  # let(:inv_item_one){ SalesEngine::InvoiceItem.new( :unit_price => "10", :quantity => "3",
  #                                                   :invoice_id => "1",  :item_id => "1" ) }
  # let(:inv_one)   { SalesEngine::Invoice.new( :id => "1", :customer_id => "1",
  #                                  :created_at => "2012-2-19" ) }
  # let(:inv_two)   { SalesEngine::Invoice.new( :id => "2", :customer_id => "2",
  #                                  :created_at => "2012-9-09" ) }
  # let(:item_one){ SalesEngine::Item.new( :id => "1") }
  # let(:item_two){ SalesEngine::Item.new( :id => "2") }

  # describe "#invoice" do
  #   it "returns an instance of invoice associated with the instance" do
  #     SalesEngine::Database.instance.invoice_list = [ inv_one, inv_two ]
  #     inv_item_one.invoice.should == inv_one

  #     context "when an invoice has an invalid invoice id" do
  #       it "returns nil" do
  #         SalesEngine::Database.instance.invoice_list = [ inv_two ]
  #         inv_item_one.invoice.should be_nil
  #       end
  #     end
  #   end
  # end

  # describe "#item" do
  #   it "returns an instance of item associated with the instance" do
  #     SalesEngine::Database.instance.item_list = [ item_one, item_two ]
  #     inv_item_one.item.should == item_one

  #     context "when an invoice has an invalid item id" do
  #       it "returns nil" do
  #         SalesEngine::Database.instance.item_list = [ item_two ]
  #         inv_item_one.item.should be_nil
  #       end
  #     end
  #   end
  # end
end