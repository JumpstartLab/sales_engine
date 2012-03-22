require './spec/spec_helper.rb'

describe Merchant do
  let(:tr_one)   { Transaction.new( :invoice_id => "1") }
  let(:tr_two)   { Transaction.new( :invoice_id => "2", :status => "failure") }
  let(:tr_three) { Transaction.new( :invoice_id => "2", :status => "success") }
  let(:tr_four)  { Transaction.new( :invoice_id => "4", :status => "failure")}
  let(:cust_one)    { Customer.new( :id => "1") }
  let(:cust_two)    { Customer.new( :id => "2") }
  let(:inv_one)     { Invoice.new( :id => "1", :customer_id => "0",
                                   :created_at => "2012-12-09" ) }
  let(:inv_two)     { Invoice.new( :id => "2", :customer_id => "2",
                                   :created_at => "2012-9-09" ) }) }
  let(:inv_three)   { Invoice.new( :id => "3", :customer_id => "0",
                                   :created_at => "2012-8-09" ) }
  let(:inv_item_one){ InvoiceItem.new( :unit_price => "10", :quantity => "3",
                                       :invoice_id => "1" ) }
  let(:inv_item_two){ InvoiceItem.new( :unit_price => "1", :quantity => "3",
                                       :invoice_id => "1") }

  describe "#transactions" do
    it "returns an array of transactions" do
        Database.instance.transaction_list = [ tr_one, tr_two, tr_three ]
        invoice_two.transactions.should == [ tr_two, tr_three ]
    end

    context "when an invoice has no transactions" do
      it "returns an empty array" do
        invoice_three.transactions.should == [ ]
      end
    end
  end

  describe ".dates_by_revenue" do
    #sum all invoice items and divide by number of invoices
    it "returns an array of date objs in descending order of revenue" do
      Database.instance.invoice_item_list = [ inv_item_one, inv_item_two ]
      Database.instance.invoice_list = [ inv_one, inv_two, inv_three ]
      Database.instance.transaction_list = [ tr_one, tr_two, tr_three, tr_four ]
      Invoice.dates_by_revenue.should == [  ]
    end
  end
end