require 'spec_helper.rb'

describe SalesEngine::Invoice do
  let(:inv_one)   { SalesEngine::Invoice.new( :id => "1", :customer_id => "1",
                                   :created_at => "2012-2-19" ) }
  let(:inv_two)   { SalesEngine::Invoice.new( :id => "2", :customer_id => "2",
                                   :created_at => "2012-9-09" ) }
  let(:inv_three) { SalesEngine::Invoice.new( :id => "3", :customer_id => "0",
                                   :created_at => "2012-8-09" ) }
  let(:invoice_list) { SalesEngine::Database.instance.invoice_list = [ inv_one, inv_two, inv_three ] }
  let(:successful_invoice_list) { SalesEngine::Database.instance.invoice_list = [ inv_two ] }

  let(:tr_one)   { SalesEngine::Transaction.new( :invoice_id => "1") }
  let(:tr_two)   { SalesEngine::Transaction.new( :invoice_id => "2", :result => "failure") }
  let(:tr_three) { SalesEngine::Transaction.new( :invoice_id => "2", :result => "success") }
  let(:tr_four)  { SalesEngine::Transaction.new( :invoice_id => "4", :result => "failure") }
  let(:transaction_list) { SalesEngine::Database.instance.transaction_list = [ tr_one, tr_two, tr_three, tr_four ] }

  let(:inv_item_one){ SalesEngine::InvoiceItem.new( :unit_price => "1000", :quantity => "3",
                                                    :invoice_id => "1",  :item_id => "1" ) }
  let(:inv_item_two){ SalesEngine::InvoiceItem.new( :unit_price => "100", :quantity => "3",
                                                    :invoice_id => "2", :item_id => "2" ) } 
  let(:inv_item_three){ SalesEngine::InvoiceItem.new( :unit_price => "1000", :quantity => "3",
                                                      :invoice_id => "1", :item_id => "2") }
  let(:inv_item_four) { SalesEngine::InvoiceItem.new( :unit_price => "100", :quantity => "3",
                                                     :invoice_id => "1", :item_id => "2")}
  let(:invoice_item_list) {SalesEngine::Database.instance.invoice_item_list = [ inv_item_one, inv_item_two, inv_item_three, inv_item_four]}

  describe ".random" do
    before(:each) do
      invoices = [ inv_one, inv_two, inv_three ]
      SalesEngine::Database.instance.stub(:invoice_list).and_return(invoices)
    end

    it "returns a random Invoice" do
        SalesEngine::Invoice.random.should be_a SalesEngine::Invoice
    end
  end

  describe "#transactions" do
    before(:each) do
      transaction_list
    end

    it "returns an array of transactions" do
        inv_two.transactions.should == [ tr_two, tr_three ]
    end

    context "when an invoice has no transactions" do
      it "returns an empty array" do
        inv_three.transactions.should == [ ]
      end
    end
  end

  describe ".create" do
    before(:each) do
      SalesEngine::InvoiceItem.stub(:create)
      SalesEngine::Database.instance.invoice_list = [ ]
    end

    let(:customer_one) { SalesEngine::Customer.new(:id => "1") }
    let(:merchant_one) { SalesEngine::Merchant.new(:id => "1") }
    let(:item_one) { SalesEngine::Item.new(:id => "1")}
    let(:invoice) { SalesEngine::Invoice.create( {:customer => customer_one, 
                                    :merchant => merchant_one, 
                                    :status => "shipped", 
                                    :items => [ item_one ] } ) }

    it "assigns a customer id" do
      invoice.customer_id.should == 1
    end

    it "assigns a merchant id" do
      invoice.merchant_id.should == 1
    end

    it "assigns a status" do
      invoice.status.should == "shipped"
    end

    it "assigns the created_at time" do
      invoice.created_at.should be_a Date
    end

    it "assigns the updated_at time" do
      invoice.updated_at.should be_a Date
    end

    it "assigns an invoice id" do
      invoice.id.should == 1
    end

    it "adds the invoice to the invoice_list" do
      SalesEngine::Database.instance.invoice_list.should include invoice
    end
  end



  describe "#is_successful?" do
    before(:each) do
      transaction_list
    end

    context "when invoice has at least one successful transaction" do 
      it "returns true" do
        inv_two.is_successful?.should be_true
      end
    end
    
    context "when invoice has no successful transactions" do 
      it "returns nil" do
        inv_three.is_successful?.should be_false
      end
    end
  end

  describe "basic finder methods" do
    SalesEngine::Invoice::INVOICE_ATTS.each do |attribute|
      it "should respond to #find_by_#{attribute}" do
        SalesEngine::Invoice.should respond_to("find_by_#{attribute}")
      end

      it "should respond to #find_all_by_#{attribute}" do
        SalesEngine::Invoice.should respond_to("find_all_by_#{attribute}")
      end
    end
  end

  describe ".pending" do
    before(:each) do
      transaction_list
    end

    it "returns an array of invoices with no successful transactions" do
      invoice_list
      SalesEngine::Invoice.pending.should == [ inv_one, inv_three ]
    end

    context "when all invoices have a successful transaction" do
      it "returns an empty array" do
        successful_invoice_list       
        SalesEngine::Invoice.pending.should == [ ]
      end
    end
  end

  describe ".average_revenue" do

    before(:each) do
      invoice_item_list
      invoice_list
      transaction_list
    end

    it "returns the average revenue for all invoices with successful transactions" do
      SalesEngine::Invoice.average_revenue.should == 3
      SalesEngine::Invoice.average_revenue.should be_a BigDecimal
    end
  end

  describe "#invoices_items" do
    before(:each) do
      invoice_item_list
    end

    it "returns an array of invoice items" do
      inv_one.invoice_items.should include inv_item_one 
    end

    context "when an invoice has no invoice items" do
      it "returns an empty array" do
        inv_three.invoice_items.should == [ ]
      end
    end
  end

  describe "#customer" do
    let(:cust_one)    { SalesEngine::Customer.new( :id => "1") }
    let(:cust_two)    { SalesEngine::Customer.new( :id => "2") }
    let(:customer_list) { SalesEngine::Database.instance.customer_list = [ cust_one, cust_two ]}

    before(:each) do
      customer_list
    end

    it "returns the customer for the invoice" do
      inv_one.customer.should == cust_one
    end

  end

  describe "#items" do
    let(:item_one){ SalesEngine::Item.new( :id => "1") }
    let(:item_two){ SalesEngine::Item.new( :id => "2") }
    let(:item_list) { SalesEngine::Database.instance.item_list = [ item_one, item_two ] }

    before(:each) do
      item_list
      invoice_list
      invoice_item_list
    end

    it "returns all items associated with that invoice" do
      inv_one.items.should include item_one 
    end

    context "when an invoice has no items" do
      it "returns an empty array" do
        inv_three.items.should == [ ]
      end
    end
  end
end
 
describe ".average_items" do
  before(:each) do
    SalesEngine::Invoice.stub(:total_items_over_period).and_return([ 10, 2 ])
    SalesEngine::Invoice.stub(:total_items_over_period).with("2012-02-19").and_return([ 10, 2 ])
  end
  it "returns the average items for processed invoices" do
    SalesEngine::Invoice.average_items.should == 5
    SalesEngine::Invoice.average_items.should be_a BigDecimal
  end

  context "when a date is specified" do
    it "returns the average total for invoices created on that date" do
      SalesEngine::Invoice.average_items("2012-02-19").should == 5
      SalesEngine::Invoice.average_items("2012-02-19").should be_a BigDecimal
    end
  end
end

describe "sum items purchased either by date or by all invoices" do
  let(:i_one)   { SalesEngine::Invoice.new( :id => "1", :created_at => "2012-11-09" ) }
  let(:i_two)   { SalesEngine::Invoice.new( :id => "2", :created_at => "2012-9-09" ) }
  let(:i_i_one){ SalesEngine::InvoiceItem.new( :quantity => "1", :unit_price => "10" ) }
  let(:i_i_two){ SalesEngine::InvoiceItem.new( :quantity => "2", :unit_price => "20" ) } 
  let(:i_i_three){ SalesEngine::InvoiceItem.new( :quantity => "3", :unit_price => "30" ) }

  before(:each) do
    SalesEngine::Invoice.stub(:successful_invoices).and_return([ i_one, i_two ])
    i_one.stub(:invoice_items).and_return([ i_i_two ])
    i_two.stub(:invoice_items).and_return([ i_i_one, i_i_three ])
  end

  describe ".items_on_all" do
    it "returns the total items purchased on all invoices" do
      SalesEngine::Invoice.items_on_all.should == [ 6, 2 ]
    end
  end

  describe ".items_on_date(date)" do
    it "returns the total items purchased on all invoices" do
      SalesEngine::Invoice.items_on_date("2012-9-09").should == [ 4, 1 ]
    end
  end
end

describe ".total_items_over_period" do
  let(:i_one)   { SalesEngine::Invoice.new( :id => "1", :created_at => "2012-11-09" ) }
  let(:i_two)   { SalesEngine::Invoice.new( :id => "2", :created_at => "2012-9-09" ) }
  let(:i_i_one){ SalesEngine::InvoiceItem.new( :quantity => "1", :unit_price => "10" ) }
  let(:i_i_two){ SalesEngine::InvoiceItem.new( :quantity => "2", :unit_price => "20" ) } 
  let(:i_i_three){ SalesEngine::InvoiceItem.new( :quantity => "3", :unit_price => "30" ) }

  before(:each) do
    SalesEngine::Invoice.stub(:successful_invoices).and_return([ i_one, i_two ])
    i_one.stub(:invoice_items).and_return([ i_i_two ])
    i_two.stub(:invoice_items).and_return([ i_i_one, i_i_three ])
  end

  describe "when a date is not specified" do
    it "returns total items" do
      SalesEngine::Invoice.total_items_over_period.should == [6, 2]
    end
  end

  describe "when a date is specified" do
    it "returns total items on that date" do
      SalesEngine::Invoice.total_items_over_period("2012-9-09").should == [4, 1]
    end
  end
end

