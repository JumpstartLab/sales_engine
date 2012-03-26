require 'spec_helper'

describe SalesEngine::Transaction do
  describe "#invoice" do
    let(:transaction) { Fabricate(:transaction, :id => 1) }
    let(:invoice) { mock(SalesEngine::Invoice) }
    let(:other_invoice) { mock(SalesEngine::Invoice) }

    before(:each) do
      invoice.stub(:id).and_return(1)
      other_invoice.stub(:id).and_return(2)
      SalesEngine::Database.stub(:invoices).and_return([invoice, other_invoice])
    end
    
    it "returns the invoice with matching invoice_id" do
      transaction.invoice.should == invoice
    end
  end
end