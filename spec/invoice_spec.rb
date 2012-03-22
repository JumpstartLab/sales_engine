require './spec/spec_helper.rb'

describe Invoice do

  let(:tr_one)   { Transaction.new( :invoice_id => "1") }
  let(:tr_two)   { Transaction.new( :invoice_id => "2", :status => "failure") }
  let(:tr_three) { Transaction.new( :invoice_id => "2", :status => "success") }
  let(:tr_four)  { Transaction.new( :invoice_id => "4", :status => "failure")}
  let(:cust_one)    { Customer.new( :id => "1") }
  let(:cust_two)    { Customer.new( :id => "2") }
  let(:inv_one)     { Invoice.new( :id => "1", :customer_id => "0",
                                   :created_at => "2012-12-09" ) }
  let(:inv_two)     { Invoice.new( :id => "2", :customer_id => "2",
                                   :created_at => "2012-9-09" ) }
  let(:inv_three)   { Invoice.new( :id => "3", :customer_id => "0",
                                   :created_at => "2012-8-09" ) }
  let(:inv_item_one){ InvoiceItem.new( :unit_price => "10", :quantity => "3",
                                       :invoice_id => "1" ) }
  let(:inv_item_two){ InvoiceItem.new( :unit_price => "1", :quantity => "3",
                                       :invoice_id => "1")}

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

  describe ".pending" do
    it "returns an array of invoices with no successful transactions" do
      Database.instance.transaction_list = [ tr_one, tr_two, tr_three, tr_four ]
      Invoice.pending.should == [ tr_two, tr_four ]
    end

    context "when all transactions are successful" do
      it "returns an empty array" do
        Database.instance.transaction_list [ tr_one, tr_three ]
        Invoice.pending.should == [ ]
      end
    end
  end

  describe ".average_revenue" do
    #sum all invoice items and divide by number of invoices
    it "returns the average total for each processed invoice" do
      Database.instance.invoice_item_list = [ inv_item_one, inv_item_two ]
      Database.instance.invoice_list = [ inv_one, inv_two, inv_three ]
      Database.instance.transaction_list = [ tr_one, tr_two, tr_three, tr_four ]
      Invoice.average_revenue.should == 11
      Invoice.average_revenue.should be_a BigDecimal
    end

    context "when a date is specified" do
      #created date or updated date?
      it "returns the average total for invoices created on that date" do
        Invoice.average_revenue("2012-02-19").should == 11
      end

      context "when a date is specified on which no invoices were created" do
        Invoice.average_revenue("2000-01-01").should == 0
      end
    end

    context "when no processed invoices" do
      it "returns 0" do
        Invoice.average_revenue.should == 0
      end
    end
  end


  describe ".average_items" do
    #average item count for each processed invoice
    context "returns the average items for processed invoices" do
      Invoice.average_items.should == 2
    end

    context "when a date is specified" do
      #created date or updated date?
      it "returns the average total for invoices created on that date" do
        Invoice.average_items("2012-02-19").should == 6
      end
    end

  end

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
   # describe "#transactions" do
  #   it "returns an array of invoices" do
  #     customer_zero.invoices.should == [invoice_one, invoice_three]
  #   end

  #   context "when customer has no invoices" do
  #     it "returns an empty array" do
  #       customer_one.invoices.should == [ ]
  #     end
  #   end
  # end
   # describe "#transactions" do
  #   it "returns an array of invoices" do
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
end