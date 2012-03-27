require 'spec_helper.rb'

describe SalesEngine::Customer do

  let(:customer_zero) { SalesEngine::Customer.new(:id => "0") }
  let(:customer_one) { SalesEngine::Customer.new(:id => "1") }
  let(:customer_two) { SalesEngine::Customer.new(:id => "2") }
  let(:customer_three) { SalesEngine::Customer.new(:id => "3") }

  let(:invoice_one) { SalesEngine::Invoice.new(:id => "1", :customer_id => "0", :merchant_id => "0") }
  let(:invoice_two) { SalesEngine::Invoice.new(:id => "2", :customer_id => "2", :merchant_id => "0") }
  let(:invoice_three) { SalesEngine::Invoice.new(:id => "3", :customer_id => "0", :merchant_id => "0") }

  let(:trans_one) { SalesEngine::Transaction.new(:id => "1", :invoice_id => "1") }
  let(:trans_two) { SalesEngine::Transaction.new(:id => "2", :invoice_id => "2", :result => "failure") }
  let(:trans_three) { SalesEngine::Transaction.new(:id => "3", :invoice_id => "2", :result => "success") }

  let(:merchant_zero){ SalesEngine::Merchant.new( :id => "0" )}

  describe "#invoices" do
    it "returns an array of invoices" do
      SalesEngine::Database.instance.invoice_list = [ invoice_one, invoice_two, invoice_three ]
      customer_zero.invoices.should == [ invoice_one, invoice_three ]
    end

    context "when customer has no invoices" do
      it "returns an empty array" do
        customer_one.invoices.should be_empty
      end
    end
  end

  describe "#transactions" do
    it "returns an array of transactions instances associated with the customer" do
      SalesEngine::Database.instance.invoice_list = [ invoice_one, invoice_two, invoice_three ]
      SalesEngine::Database.instance.transaction_list = [ trans_one, trans_two, trans_three ]
      customer_two.transactions.should == [ trans_two, trans_three ]
    end

    context "when a customer has no transactions" do
      it "returns an empty array" do
        SalesEngine::Database.instance.invoice_list = [ invoice_one, invoice_two, invoice_three ]
        SalesEngine::Database.instance.transaction_list = [ trans_one, trans_two, trans_three ]
        customer_one.transactions.should be_empty
      end
    end
  end

  describe "#successful_transactions" do
    let(:trans_one)     { mock(SalesEngine::Transaction) }
    let(:trans_two)     { mock(SalesEngine::Transaction) }
    let(:trans_three)   { mock(SalesEngine::Transaction) }

    before(:each) do
      trans_one.stub(:is_successful?).and_return(true)
      trans_two.stub(:is_successful?).and_return(true)
      trans_three.stub(:is_successful?).and_return(false)
      transactions = [ trans_one, trans_two, trans_three ]
      customer_one.stub(:transactions).and_return(transactions)
    end
   
    it "returns successful transactions associated with the customer" do
      customer_one.successful_transactions.should == [ trans_one, trans_two ]
    end

    context "when no successful transactions" do
      it "returns an empty array" do
        customer_three.successful_transactions.should == [ ]
      end
    end
  end

  describe "#successful_invoices" do
    let(:inv_one)     { mock(SalesEngine::Invoice) }
    let(:inv_two)     { mock(SalesEngine::Invoice) }
    let(:inv_three)   { mock(SalesEngine::Invoice) }

    before(:each) do
      trans_one.stub(:invoice_id).and_return("1")
      trans_two.stub(:invoice_id).and_return("2")
      inv_one.stub(:id).and_return("1")
      inv_two.stub(:id).and_return("2")
      successful_trans = [ trans_one, trans_two ]
      customer_one.stub(:successful_transactions).and_return(successful_trans)
      invoices = [ inv_one, inv_two ]
      SalesEngine::Database.instance.stub(:invoice_list).and_return(invoices)
    end
   
    it "returns successful invoices associated with the customer" do
      customer_one.successful_invoices.should == [ inv_one, inv_two ]
    end

    context "when no successful transactions" do
      it "returns an empty array" do
        customer_one.stub(:successful_transactions).and_return([ ])
        customer_one.successful_invoices.should == [ ]
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


  # describe ".random" do
  #   it "returns a random instance of customer in customer_list" do
  #   end

  #   context "returns nil when there are no customers" do
  #   end
  # end

  # describe ".find_by_id" do
  #   it "returns a single customer whose id matches param" do
  #   end

  #   context "returns nil when there are no customers" do
  #   end
  # end

  # describe ".find_by_first_name" do
  #   it "returns a single customer whose first_name matches param" do
  #   end

  #   context "returns nil when there are no customers" do
  #   end
  # end

  # describe ".find_by_last_name" do
  #   it "returns a single customer whose last_name matches param" do
  #   end

  #   context "returns nil when there are no customers" do
  #   end
  # end

  # describe ".find_by_created_at" do
  #   it "returns a single customer whose created_at matches param" do
  #   end

  #   context "returns nil when there are no customers" do
  #   end
  # end

  # describe ".find_by_updated_at" do
  #   it "returns a single customer whose updated_at matches param" do
  #   end

  #   context "returns nil when there are no customers" do
  #   end
  # end
end