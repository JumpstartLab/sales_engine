require 'spec_helper'

describe SalesEngine::Invoice do
  param = {:id => 1, :customer_id => 1, 
           :merchant_id => 92, :status => "shipped", 
           :created_at => "2012-02-14 20:56:56 UTC", 
           :updated_at => "2012-02-26 20:56:56 UTC"}

  let(:invoice) {SalesEngine::Invoice.new(param)}
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

  let(:invoices) {SalesEngine::Database.instance.invoices}
  describe '.collection' do
    it 'creates an array' do
      invoices.should be_a(Array)
    end
    it 'contains instances of the invoice class' do
      invoices.first.class.should == invoice.class
    end
    it 'is not empty' do
      invoices.should_not be_empty
    end
  end

  describe '#transactions' do
    let(:all_transactions) {SalesEngine::Database.instance.transactions}
    it "returns an array" do
      invoice.transactions.should be_a(Array)
    end
    it 'returns instances of the transaction class' do
      invoice = invoices[0]
      result = invoice.transactions[0]
      result.class.should == all_transactions[0].class
    end
    it 'returns an empty array if no results found' do
      invoice.transactions.should == []
    end
  end

  describe '#invoice_items' do
    let(:all_invoiceitems) {SalesEngine::Database.instance.invoiceitems}
    it "returns an array" do
      invoice.invoice_items.should be_a(Array)
    end
    it 'returns instances of the invoiceitem class' do
      invoice = invoices[0]
      an_invoiceitem = invoice.invoice_items[0]
      an_invoiceitem.class.should == SalesEngine::InvoiceItem
    end
    it 'returns an empty array if no results found' do
      invoice.transactions.should == []
    end
  end

  describe '#items' do
    it 'returns an array of items' do
      invoice.items.class.should == Array
    end
    it 'matches invoiceitems to invoices by id' do
      invoice = invoices[0]
      an_invoiceitem = invoice.invoice_items[0]
      invoice.id.should == an_invoiceitem.invoice_id
    end
    it 'matches invoiceitems to items by id' do
      invoice = invoices[0]
      an_invoiceitem = invoice.invoice_items[0]
      an_item = invoice.items[0]
      an_invoiceitem.item_id.should == an_item.id     
    end
  end
  
  describe '#customer' do
    it "returns a Customer" do
      invoices[0].customer.class.should == SalesEngine::Customer
    end
    it 'matches customer id with instantiated invoice\'s customer_id' do
      invoices[0].customer.id.to_i.should == invoice.customer_id
    end
  end
end