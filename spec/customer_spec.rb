require 'spec_helper'

describe SalesEngine::Customer do
  describe "#invoices" do
    let(:customer) { SalesEngine::Customer.new(1, "", "", Date.today, Date.today) }
    let(:invoice) { mock(SalesEngine::Invoice) }
    let(:invoice2) { mock(SalesEngine::Invoice) }
    let(:other_invoice) { mock(SalesEngine::Invoice) }

    before(:each) do
      invoice.stub(:customer_id).and_return(1)
      invoice2.stub(:customer_id).and_return(2)
      other_invoice.stub(:customer_id).and_return(1)
      SalesEngine::Database.stub(:invoices).and_return([invoice, invoice2 , other_invoice])
    end
    
    context "when customer has multiple invoices" do
      let(:customer) { SalesEngine::Customer.new(1, "", "", Date.today, Date.today) }
      it "returns an array of invoices with matching invoice_id" do
        customer.invoices.should == [invoice, other_invoice]
      end
    end

    context "when customer has one invoice" do
      let(:customer) { SalesEngine::Customer.new(2, "", "", Date.today, Date.today) }
      it "returns an array with one invoice" do
        customer.invoices.should == [invoice2]
      end
    end

    context "when customer has no invoices" do
      let(:customer) { SalesEngine::Customer.new(3, "", "", Date.today, Date.today) }
      it "returns an empty array" do
        customer.invoices.should == []
      end
    end
  end
end