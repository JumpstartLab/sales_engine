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
  let(:tr_four)  { SalesEngine::Transaction.new( :invoice_id => "3", :result => "failure") }
  let(:transaction_list) { SalesEngine::Database.instance.transaction_list = [ tr_one, tr_two, tr_three ] }

  let(:inv_item_one){ SalesEngine::InvoiceItem.new( :unit_price => "10", :quantity => "3",
                                                    :invoice_id => "1",  :item_id => "1" ) }
  let(:inv_item_two){ SalesEngine::InvoiceItem.new( :unit_price => "1", :quantity => "3",
                                                    :invoice_id => "2", :item_id => "2" ) } 
  let(:inv_item_three){ SalesEngine::InvoiceItem.new( :unit_price => "10", :quantity => "3") }
  let(:inv_item_four) { SalesEngine::InvoiceItem.new( :unit_price => "1", :quantity => "3")}
  let(:invoice_item_list) {SalesEngine::Database.instance.invoice_item_list = [ inv_item_one, inv_item_two, inv_item_three, inv_item_four]}

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

  # DOESN'T WORK - need to do later
  # describe ".create" do
  #   it "creates a new invoice from hash" do
  #     invoice_params = {:customer_id => "3", :merchant_id => "5", :status => "shipped", :items => [ item_one, item_two ], :transaction => transaction}
  #     # SalesEngine::Invoice.new({ :customer_id => customer.id, :merchant_id => merchant.id, :status => status })
  #   end
  # end

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
      successful_invoice_list
      transaction_list
    end

    it "returns the average revenue for all invoices with successful transactions" do
      SalesEngine::Invoice.average_revenue.should == 3
      SalesEngine::Invoice.average_revenue.should be_a BigDecimal
    end

    # context "when a valid date is specified" do
    #   it "returns the average revenue for invoices created on that date" do
    #     SalesEngine::Database.instance.invoice_item_list = [ inv_item_one, inv_item_two ]
    #     SalesEngine::Database.instance.invoice_list = [ inv_one, inv_two, inv_three ]
    #     SalesEngine::Database.instance.transaction_list = [ tr_one, tr_two, tr_three, tr_four ]
    #     SalesEngine::Invoice.average_revenue("2012-02-19").should == 0
    #   end
    # end

    # context "when a date is specified on which no invoices were created" do
    #   it "returns 0" do
    #     SalesEngine::Invoice.average_revenue("2000-01-01").should == 0
    #   end
    # end

    # context "when there are no invoices" do
    #   it "returns 0" do
    #     SalesEngine::Database.instance.invoice_list = []
    #     SalesEngine::Database.instance.invoice_item_list = [ inv_item_three, inv_item_four ]
    #     SalesEngine::Invoice.average_revenue.should == 0
    #   end
    # end
  end

  describe "#invoices_items" do
    before(:each) do
      invoice_item_list
    end

    it "returns an array of invoice items" do
      inv_one.invoice_items.should == [ inv_item_one ]
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

    context "when an invoice has no customer" do
      it "returns nil" do
        inv_three.customer.should be_nil
      end
    end
  end

  describe "#items" do
    let(:item_one){ SalesEngine::Item.new( :id => "1") }
    let(:item_two){ SalesEngine::Item.new( :id => "2") }
    let(:item_list) { SalesEngine::Database.instance.item_list = [ item_one, item_two ] }

    before(:each) do
      item_list
      invoice_item_list
    end

    it "returns all items associated with that invoice" do
      inv_one.items.should == [ item_one ]
    end

    context "when an invoice has no items" do
      it "returns an empty array" do
        inv_three.items.should == [ ]
      end
    end
  end
end
  # describe ".average_items" do
  #   #average item count for each processed invoice
  #   context "returns the average items for processed invoices" do
  #     SalesEngine::Invoice.average_items.should == 2
  #   end

  #   context "when a date is specified" do
  #     #created date or updated date?
  #     it "returns the average total for invoices created on that date" do
  #       SalesEngine::Invoice.average_items("2012-02-19").should == 6
  #     end
  #   end
  # end

  # describe "#invoice_items" do
  #   it "returns an array of invoices_items" do
  #     customer_zero.invoices.should == [invoice_one, invoice_three]
  #   end

  #   context "when customer has no invoices" do
  #     it "returns an empty array" do
  #       customer_one.invoices.should == [ ]
  #     end
  #   end
  # end

describe ".random" do
  it "returns a random instance of customer in customer_list" do
  end

  context "returns nil when there are no customers" do
  end
end

describe ".find_by_id" do
  it "returns a single customer whose id matches param" do
  end

  context "returns nil when there are no customers" do
  end
end

describe ".find_by_first_name" do
  it "returns a single customer whose first_name matches param" do
  end

  context "returns nil when there are no customers" do
  end
end

describe ".find_by_last_name" do
  it "returns a single customer whose last_name matches param" do
  end

  context "returns nil when there are no customers" do
  end
end

describe ".find_by_created_at" do
  it "returns a single customer whose created_at matches param" do
  end

  context "returns nil when there are no customers" do
  end
end

describe ".find_by_updated_at" do
  it "returns a single customer whose updated_at matches param" do
  end

  context "returns nil when there are no customers" do
  end

end