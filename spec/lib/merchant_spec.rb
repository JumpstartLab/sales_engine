require 'spec_helper.rb'

describe SalesEngine::Merchant do
  let(:tr_one)   { SalesEngine::Transaction.new( :invoice_id => "1") }
  let(:tr_two)   { SalesEngine::Transaction.new( :invoice_id => "2", :status => "failure") }
  let(:tr_three) { SalesEngine::Transaction.new( :invoice_id => "2", :status => "success") }
  let(:tr_four)  { SalesEngine::Transaction.new( :invoice_id => "4", :status => "failure")}
  let(:cust_one)    { SalesEngine::Customer.new( :id => "1") }
  let(:cust_two)    { SalesEngine::Customer.new( :id => "2") }
  let(:inv_one)     { SalesEngine::Invoice.new( :id => "1", :merchant_id => "0",
                                   :created_at => "2012-12-09" ) }
  let(:inv_two)     { SalesEngine::Invoice.new( :id => "2", :merchant_id => "2",
                                   :created_at => "2012-9-09" ) }
  let(:inv_three)   { SalesEngine::Invoice.new( :id => "3", :merchant_id => "0",
                                   :created_at => "2012-8-09" ) }
  let(:inv_item_one){ SalesEngine::InvoiceItem.new( :unit_price => "10", :quantity => "3",
                                       :invoice_id => "1" ) }
  let(:inv_item_two){ SalesEngine::InvoiceItem.new( :unit_price => "1", :quantity => "3",
                                       :invoice_id => "1")}
  let(:merchant_zero){ SalesEngine::Merchant.new( :id => "0" )}
  let(:item_one){ SalesEngine::Item.new( :id => "1", :merchant_id => "0" ) }
  let(:item_two){ SalesEngine::Item.new( :id => "2", :merchant_id => "1" )}

  describe "#invoices" do
    it "returns a collection of invoices associated with the merchant" do
      SalesEngine::Database.instance.invoice_list = [ inv_one, inv_two, inv_three ]
      merchant_zero.invoices.should == [ inv_one, inv_three ]
    end

    context "when a merchant has no invoices" do
      it "returns an empty array" do
        SalesEngine::Database.instance.invoice_list = [ inv_two ]
        merchant_zero.invoices.should be_empty
      end
    end
  end

  describe "#items" do
    it "returns a collection of items associated with the merchant" do
      SalesEngine::Database.instance.item_list = [ item_one, item_two ]
      merchant_zero.items.should == [ item_one ]
    end

    context "when a merchant has no items" do
      it "returns an empty array" do
        SalesEngine::Database.instance.item_list = [ item_two ]
        merchant_zero.items.should be_empty
      end
    end
  end

  # describe ".dates_by_revenue" do
  #   #sum all invoice items and divide by number of invoices
  #   it "returns an array of date objs in descending order of revenue" do
  #     Database.instance.invoice_item_list = [ inv_item_one, inv_item_two ]
  #     Database.instance.invoice_list = [ inv_one, inv_two, inv_three ]
  #     Database.instance.transaction_list = [ tr_one, tr_two, tr_three, tr_four ]
  #     Invoice.dates_by_revenue.should == [  ]
  #   end
  # end
end