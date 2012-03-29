require 'spec_helper'

describe SalesEngine::InvoiceItem do
  param = {:id => 1, :item_id => 2131, :invoice_id => 1,
           :quantity => 1, :unit_price => 48545,
           :created_at => "2012-02-26 20:56:56 UTC",
           :updated_at => "2012-02-26 20:56:56 UTC"}
  let(:invoice_item) {SalesEngine::InvoiceItem.new(param)}
  describe '.initialize' do
    context "when instantiating a new invoice item" do
      it 'receives a hash as a param' do
        param.should be_a(Hash)
      end
      [:id, :item_id, :invoice_id, :quantity,
       :unit_price, :created_at, :updated_at].each do |method|
        it "sets the invoice item's attribute #{method}
        with the method #{method}" do
          invoice_item.send(method).should_not be_nil
        end
      end
    end
  end

  let(:invoiceitems) {SalesEngine::Database.instance.invoiceitems}
  describe '.collection' do
    it 'creates an array' do
      invoiceitems.should be_a(Array)
    end
    it 'contains instances of the invoice item class' do
      invoiceitems.first.class.should == invoice_item.class
    end
    it 'is not empty' do
      invoiceitems.should_not be_empty
    end
  end

  describe '.database' do
    it 'proxies to Database' do
      SalesEngine::Database.should_receive(:instance)
      SalesEngine::InvoiceItem.database
    end
  end

  describe '#database' do
    it 'proxies to Database' do
      SalesEngine::Database.should_receive(:instance)
      invoice_item.database
    end
  end

  describe '#database=' do
    it 'proxies to Database' do
      SalesEngine::Database.should_receive(:instance)
      invoice_item.database
    end
  end

  describe '#invoice' do
    it 'returns an invoice' do
      invoiceitems[0].invoice.class.should == SalesEngine::Invoice
    end
    it 'matches invoice id with instantiated invoice item\'s invoice_id' do
      invoiceitems[0].invoice.id.to_i.should == invoice_item.invoice_id
    end
  end

  describe '#item' do
    it 'returns an item' do
      invoiceitems[0].item.class.should == SalesEngine::Item
    end
    it 'matches item id with instantiated invoice item\'s item_id' do
      invoiceitems[0].item.id.should == invoiceitems[0].item_id
    end
  end

  describe '#revenue' do
    it 'returns revenue for invoice_item' do
      #(invoice_item.quantity.to_i *
        # invoice_item.unit_price.to_i).should == invoice.revenue
    end
  end

end