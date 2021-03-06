require 'spec_helper.rb'

describe SalesEngine::InvoiceItem do

  let(:inv_item_one){ SalesEngine::InvoiceItem.new( :id => "1",
                                                    :unit_price => "1000",
                                                    :quantity => "3",
                                                    :invoice_id => "1",
                                                    :item_id => "1" ) }
  let(:inv_item_two){ SalesEngine::InvoiceItem.new( :id => "2",
                                                    :unit_price => "100",
                                                    :quantity => "3",
                                                    :invoice_id => "2",
                                                    :item_id => "2" ) }
  let(:inv_one)   { SalesEngine::Invoice.new( :id => "1", :customer_id => "1",
                                   :updated_at => "2012-2-19" ) }
  let(:inv_two)   { SalesEngine::Invoice.new( :id => "2", :customer_id => "2",
                                   :updated_at => "2012-9-09" ) }
  let(:item_one){ SalesEngine::Item.new( :id => "1", :merchant_id => "1") }
  let(:item_two){ SalesEngine::Item.new( :id => "2", :merchant_id => "2") }
  let(:tr_one)   { SalesEngine::Transaction.new( :invoice_id => "1") }
  let(:tr_two)   { SalesEngine::Transaction.new( :invoice_id => "2",
                                                 :result => "failure") }
  let(:tr_three) { SalesEngine::Transaction.new( :invoice_id => "2",
                                                 :result => "success") }
  let(:tr_four)  { SalesEngine::Transaction.new( :invoice_id => "3", 
                                                 :result => "failure") }
  let(:transactions )   { [ tr_one, tr_two, tr_three, tr_four ] }
  let(:transaction_list) { SalesEngine::Database.instance.transaction_list = transactions }
  let(:invoice_list) { SalesEngine::Database.instance.invoice_list = [ inv_one, inv_two ]}
  let(:invoice_item) { }

  describe "#invoice" do
    it "returns an instance of invoice associated with the instance" do
      SalesEngine::Database.instance.invoice_list = [ inv_one, inv_two ]
      inv_item_one.invoice.should == inv_one
    end
  end

  describe "#item" do
    it "returns an instance of item associated with the invoice item" do
      SalesEngine::Database.instance.item_list = [ item_one, item_two ]
      inv_item_one.item.should == item_one
    end
  end

  describe ".create" do
    let(:invoice) { SalesEngine::Invoice.new(:id => "1") }
    let(:item) { SalesEngine::Item.new(:id => "1", :unit_price => "900" ) }

    before(:each) do
      SalesEngine::Database.instance.invoice_item_list = [ ]
      @invoice_item = SalesEngine::InvoiceItem.create( { :invoice_id => invoice.id, :item => item })
    end

    it "assigns invoice id" do
      @invoice_item.invoice_id.should == 1
    end

    it "assigns an id" do
      @invoice_item.id.should == 1
    end

    it "assigns the item id" do
      @invoice_item.item_id.should == 1
    end

    it "assigns the unit price" do
      @invoice_item.unit_price.should == BigDecimal.new("9")
    end

    it "assigns a quantity" do
      @invoice_item.quantity.should == 1
    end

    it "adds it to the invoice_item_list" do
      SalesEngine::Database.instance.invoice_item_list.should include @invoice_item
    end

  end

  describe "#merchant_id" do
    it "returns the merchant_id associated with the invoice item" do
      SalesEngine::Database.instance.item_list = [ item_one, item_two ]
      inv_item_one.merchant_id.should == 1
    end
  end


  describe ".successful_invoice_items" do
    it "returns an array of the successful invoice items" do
      transaction_list
      invoice_list
      SalesEngine::Database.instance.invoice_item_list = [ inv_item_one, inv_item_two ]
      SalesEngine::InvoiceItem.successful_invoice_items.should == [ inv_item_two ]
    end
  end

  describe ".total_revenue" do
    it "returns the total revenue for all invoice items with successful
    transactions" do
      transaction_list
      invoice_list
      SalesEngine::InvoiceItem.total_revenue.should == 3
    end
  end

  describe "#is_successful?" do

    before do
      transaction_list
      invoice_list
    end

    context "when an invoice item is on an invoice with at least one successful
    transaction" do
      it "returns one successful transaction" do
        inv_item_two.is_successful?.should be_true
      end
    end

    context "when an invoice item is on an invoice that has no successful
    transactions" do
      it "should be false" do
        inv_item_one.is_successful?.should be_false
      end
    end
  end

end