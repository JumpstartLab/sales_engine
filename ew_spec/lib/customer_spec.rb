require 'spec_helper.rb'

describe SalesEngine::Customer do

  let(:customer_zero) { SalesEngine::Customer.new(:id => "0") }
  let(:customer_one) { SalesEngine::Customer.new(:id => "1") }
  let(:customer_two) { SalesEngine::Customer.new(:id => "2") }
  let(:customer_three) { SalesEngine::Customer.new(:id => "3") }

  let(:invoice_one) { SalesEngine::Invoice.new( :id => "1",
                                                :customer_id => "0",
                                                :merchant_id => "0") }
  let(:invoice_two) { SalesEngine::Invoice.new( :id => "2",
                                                :customer_id => "2",
                                                :merchant_id => "0") }
  let(:invoice_three) { SalesEngine::Invoice.new( :id => "3",
                                                  :customer_id => "0",
                                                  :merchant_id => "0") }
  let(:invoices) { [ invoice_one, invoice_two, invoice_three ] }
  let(:invoice_list) { SalesEngine::Database.instance.invoice_list = invoices }

  let(:trans_one) { SalesEngine::Transaction.new( :id => "1",
                                                  :invoice_id => "1") }
  let(:trans_two) { SalesEngine::Transaction.new( :id => "2",
                                                  :invoice_id => "2",
                                                  :result => "failure") }
  let(:trans_three) { SalesEngine::Transaction.new( :id => "3",
                                                    :invoice_id => "2",
                                                    :result => "success") }
  let(:inv_item_one){ SalesEngine::InvoiceItem.new( :id => "1",
                                                    :unit_price => "1000",
                                                    :quantity => "3",
                                                    :invoice_id => "2",
                                                    :item_id => "1" ) }
  let(:transactions) { [ trans_one, trans_two, trans_three ] }

  let(:transaction_list) { SalesEngine::Database.instance.transaction_list = transactions }

  let(:merchant_zero){ SalesEngine::Merchant.new( :id => "0" )}

  describe "#invoices" do
    it "returns that customer's invoices in an array" do
      invoice_list
      customer_zero.invoices.should == [ invoice_one, invoice_three ]
    end

    context "when customer has no invoices" do
      it "returns an empty array" do
        customer_one.invoices.should be_empty
      end
    end
  end

  describe "basic finder methods" do
    SalesEngine::Customer::CUSTOMER_ATTS.each do |attribute|
      it "should respond to #find_by_#{attribute}" do
        SalesEngine::Customer.should respond_to("find_by_#{attribute}")
      end

      it "should respond to #find_all_by_#{attribute}" do
        SalesEngine::Customer.should respond_to("find_all_by_#{attribute}")
      end
    end
  end

  describe ".most_revenue" do
    before(:each) do
      SalesEngine::Customer.stub(:customers_by_revenue_bought).and_return({ customer_two.id => 3000 })
    end
    it "returns the customer with the most revenue" do
      SalesEngine::Customer.most_revenue.should == customer_two
    end
  end

  describe ".most_items" do
    before(:each) do
      SalesEngine::Customer.stub(:customers_by_items_bought).and_return({ customer_two.id => 3 })
    end
    it "returns the customer who bought the most items" do
      SalesEngine::Customer.most_items.should == customer_two
    end
  end

  describe "#pending_invoices" do
    let(:customer) { SalesEngine::Customer.new(:id => "0") }
    let(:invoice) { SalesEngine::Invoice.new( :id => "1",
                                                :customer_id => "0",
                                                :merchant_id => "0") }
    let(:trans) { SalesEngine::Transaction.new( :id => "1",
                                                  :invoice_id => "1",
                                                  :result => "fail") }
    let(:transaction_array) { [ trans ] }

    before(:each) {invoice.stub(:transactions).and_return(transaction_array)}
    it "returns an array of invoices with no successful trans" do
      customer.pending_invoices.should == [ invoice ]
    end
  end

  describe ".customers_by_revenue_bought" do
    before(:each) do
      SalesEngine::Customer.stub(:paid_invoices).and_return([ invoice_two ])
    end
    it "returns a hash of customers and revenue" do
      SalesEngine::Customer.customers_by_revenue_bought.should include customer_two.id
    end
  end


  describe ".customers_by_items_bought" do
    before(:each) do
      SalesEngine::Customer.stub(:paid_invoice_items).and_return([ inv_item_one ])
    end

    it "returns a hash of customers and quantity of items" do
      SalesEngine::Customer.customers_by_items_bought.should == {customer_two.id => 3}
    end
  end


  describe "#days_since_activity" do
    let(:customer) { SalesEngine::Customer.new(:id => "1") }
    let(:invoice) { SalesEngine::Invoice.new(:id => "1",
                                              :invoice_id => "1",
                                              :customer_id => "1",
                                              :created_at => "2012-03-28")}
    let(:transaction) { SalesEngine::Transaction.new(:id => "1", :result => "success", 
                                                     :invoice_id => "1")}
    let(:invoices) {[invoice]}
    before(:each) { customer.stub(:paid_invoices).and_return(invoices) }

    it "returns a count of the days since customer's last transaction" do
      customer.days_since_activity.should == 1
    end
  end

  describe "#transactions" do
    before(:each) do
      invoice_list
      transaction_list
    end

    it "returns an array of transactions instances associated with the customer" do
      customer_two.transactions.should == [ trans_two, trans_three ]
    end

    context "when a customer has no transactions" do
      it "returns an empty array" do
        customer_one.transactions.should be_empty
      end
    end
  end

  describe "#successful_invoices" do
    let(:inv_one)     { mock(SalesEngine::Invoice) }
    let(:inv_two)     { mock(SalesEngine::Invoice) }
    let(:inv_three)   { mock(SalesEngine::Invoice) }

    before(:each) do
      inv_one.stub(:is_successful?).and_return(true)
      inv_two.stub(:is_successful?).and_return(true)
      inv_three.stub(:is_successful?).and_return(false)

      invoices = [ inv_one, inv_two, inv_three ]
      customer_one.stub(:invoices).and_return(invoices)
    end
   
    it "returns successful invoices associated with the customer" do
      customer_one.paid_invoices.should == [ inv_one, inv_two ]
    end

    context "when no successful transactions" do
      it "returns an empty array" do
        invoices = [ inv_three ]
        customer_one.stub(:invoices).and_return(invoices)
        customer_one.paid_invoices.should == [ ]
      end
    end
  end

  describe "#favorite_merchant" do
    it "returns merchant with whom the customer has conducted the most successful transactions" do
      SalesEngine::Database.instance.invoice_list = [ invoice_one, invoice_two, invoice_three ]
      SalesEngine::Database.instance.transaction_list = [ trans_one, trans_two, trans_three ]
      SalesEngine::Database.instance.merchant_list = [ merchant_zero ]
      customer_two.favorite_merchant.should == merchant_zero
    end

    context "when a customer has not had any successful transactions" do
      it "returns nil" do
        customer_one.favorite_merchant.should be_nil
      end
    end
  end
end