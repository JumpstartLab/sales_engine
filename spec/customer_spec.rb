require 'spec_helper'

describe SalesEngine::Customer do
  describe "#invoices" do
    let(:customer) { Fabricate(:customer, :id => 1) }
    let(:invoice) { mock(SalesEngine::Invoice) }
    let(:invoice2) { mock(SalesEngine::Invoice) }
    let(:other_invoice) { mock(SalesEngine::Invoice) }

    before(:each) do
      invoice.stub(:customer_id).and_return(1)
      invoice2.stub(:customer_id).and_return(2)
      other_invoice.stub(:customer_id).and_return(1)
      SalesEngine::Database.instance.stub(:invoices).and_return([invoice, invoice2 , other_invoice])
    end
    
    context "when customer has multiple invoices" do
      let(:customer) { Fabricate(:customer, :id => 1) }
      it "returns an array of invoices with matching invoice_id" do
        customer.invoices.should == [invoice, other_invoice]
      end
    end

    context "when customer has one invoice" do
      let(:customer) { Fabricate(:customer, :id => 2) }
      it "returns an array with one invoice" do
        customer.invoices.should == [invoice2]
      end
    end

    context "when customer has no invoices" do
      let(:customer) { Fabricate(:customer, :id => 3) }
      it "returns an empty array" do
        customer.invoices.should == []
      end
    end
  end
  
  describe "#transactions" do
    let(:customer) { Fabricate(:customer, :id => 1) }
    let(:transaction) { double("transaction") } 
    let(:other_transaction) { double("transaction") } 

    context "multiple transactions" do 
      it "returns an array of transactions" do
        SalesEngine::Database.instance.stub(:transactions_by_customer).with(1).
          and_return([transaction, other_transaction])
        customer.transactions.should == [transaction, other_transaction]
      end
    end

    context "one transaction" do
      it "returns an array of one transaction" do
        SalesEngine::Database.instance.stub(:transactions_by_customer).with(1).
          and_return([transaction])
        customer.transactions.should == [transaction]
      end
    end

    context "no transactions" do
      it "returns an empty array" do
        SalesEngine::Database.instance.stub(:transactions_by_customer).with(1).
          and_return([])
        customer.transactions.should == []
      end
    end
  end

  describe "#has_pending_invoices?" do
    let(:customer) { Fabricate(:customer, :id => 1) }
    let(:invoice1) { double("invoice", :status => "pending") }
    let(:invoice2) { double("invoice", :status => "shipped") }
    let(:invoice3) { double("invoice", :status => "shipped") }

    context "the customer has invoices" do
      context "one or more of the invoices are pending" do
        it "returns true" do
          customer.stub(:invoices).and_return([invoice1, invoice2, invoice3])
          customer.has_pending_invoice?.should == true
        end
      end
      context "none of the invoices are pending" do
        it "returns false" do
          customer.stub(:invoices).and_return([invoice2, invoice3])
          customer.has_pending_invoice?.should == false
        end
      end
    end
    context "the customer has no invoices" do
      it "returns false" do
        customer.stub(:invoices).and_return([])
        customer.has_pending_invoice?.should == false
      end
    end
  end

  describe "#favorite_merchant" do
    let(:customer) { Fabricate(:customer, :id => 1) }
    let(:invoice) { double("invoice", :customer_id => 1, 
                               :merchant_id => 100) } 
    let(:invoice2) { double("invoice", :customer_id => 2, 
                               :merchant_id => 2) } 
    let(:invoice3) { double("invoice", :customer_id => 1, 
                               :merchant_id => 20) } 
    let(:other_invoice) { double("invoice", :customer_id => 1,
                               :merchant_id => 100) } 
    let(:merchant) { Fabricate(:merchant, :id => 100) }

    context "when transactions with more than one merchant" do 
      it "returns merchant with most transactions" do
        customer.stub(:invoices).and_return([invoice, invoice3, other_invoice])
        SalesEngine::Merchant.stub(:find_by_id).with(100).and_return(merchant)
        customer.favorite_merchant.should == merchant
      end
    end

    context "when no transactions" do
      it "returns nil" do
        customer.stub(:invoices).and_return([])
        customer.favorite_merchant.should == nil
      end
    end
  end
end
