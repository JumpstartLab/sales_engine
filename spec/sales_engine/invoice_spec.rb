require 'spec_helper'

describe SalesEngine::Invoice do
  param = {:id => 1, :customer_id => 1, 
           :merchant_id => 92, :status => "shipped", 
           :created_at => "2012-02-14 20:56:56 UTC", 
           :updated_at => "2012-02-26 20:56:56 UTC"}
  let(:invoice) {SalesEngine::Invoice.new(param)}
  #let(:invoice) { Fabricate(:invoice) }
  describe '.initialize' do
    context "when instantiating a new invoice" do
      it 'receives a hash as a param' do
        param.should be_a(Hash)
      end
      [:id, :customer_id, :merchant_id, :status, :created_at, :updated_at].each do |method|
        it "sets the invoice's attribute #{method} with the method #{method}" do
          invoice.send(method).should_not be_nil
        end
      end
    end
  end

  let(:collection) {SalesEngine::Database.instance.invoices}
  describe '.collection' do
    it 'creates an array' do
      collection.should be_a(Array)
    end
    it 'contains instances of the invoice class' do
      collection.first.class.should == invoice.class
    end
    it 'is not nil' do
      collection.should_not be_nil
    end
  end

  describe '.transactions' do
    let(:dbtransactions) {SalesEngine::Database.instance.transactions}
    it "returns an array" do
      invoice.transactions.should be_a(Array)
    end
    it 'returns instances of the transaction class' do
      invoice = collection[0]
      result = invoice.transactions[0]
      result.class.should == dbtransactions[0].class
    end
    it 'returns an empty array if no results found' do
      invoice.transactions.should == []
    end
  end
  describe '.invoice_items' do
    let(:dbinvoiceitems) {SalesEngine::Database.instance.invoiceitems}
    it "returns an array" do
      invoice.invoice_items.should be_a(Array)
    end
    it 'returns instances of the invoiceitem class' do
      invoice = collection[0]
      result = invoice.invoice_items[0]
      result.class.should == dbinvoiceitems[0].class
    end
    it 'returns an empty array if no results found' do
      invoice.transactions.should == []
    end
  end
  describe '.items' do
    it 'returns an array of items' do
      pending
    end
    it 'matches invoiceitems to invoices by id' do
      pending
    end
    it 'matches invoiceitems to items by id' do
      pending
    end
  end
  describe '.customer' do
    let(:dbcustomers) {SalesEngine::Database.instance.customers}
    it "returns a Customer" do
      collection[0].customer.class.should == SalesEngine::Customer
    end
    it 'matches customer id with instantiated invoice\'s customer_id' do
      collection[0].customer.id.to_i.should == invoice.customer_id
    end
  end


end