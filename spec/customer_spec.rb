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
end
