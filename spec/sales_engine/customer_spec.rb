require 'spec_helper'

describe SalesEngine::Customer do
  param = {:id => 1, :first_name => "Eliezer", :last_name => "Lemke",
           :created_at => "2012-02-26 20:56:56 UTC",
           :updated_at => "2012-02-26 20:56:56 UTC"}

  let(:collection) {SalesEngine::Database.instance.customers}
  let(:fake_customer) {SalesEngine::Customer.new(param)}
  let(:customer) {collection[0]}
  let(:invoices) {SalesEngine::Invoice.find_all_by_customer_id(customer.id)}

  describe 'initialize' do
    context "when instantiating a new customer" do
      it 'receives a hash as a param' do
        param.should be_a(Hash)
      end
      [:id, :first_name, :last_name, :created_at, :updated_at].each do |method|
        it "sets the customer's attribute #{method}
        with the method #{method}" do
          fake_customer.send(method).should_not be_nil
        end
      end
    end
  end

  describe '.collection' do
    it 'creates an array' do
      collection.should be_a(Array)
    end
    it 'contains instances of the customer class' do
      collection.first.class.should == fake_customer.class
    end
    it 'is not empty' do
      collection.should_not be_empty
    end
  end

  describe '.database' do
    it 'proxies to Database' do
      SalesEngine::Database.should_receive(:instance)
      SalesEngine::Customer.database
    end
  end

  describe '#database' do
    it 'proxies to Database' do
      SalesEngine::Database.should_receive(:instance)
      fake_customer.database
    end
  end

  describe '#database=' do
    it 'proxies to Database' do
      SalesEngine::Database.should_receive(:instance)
      fake_customer.database
    end
  end

  describe '#invoices' do
  let(:dbinvoices) {SalesEngine::Database.instance.invoices}
    it "returns an array" do
      fake_customer.invoices.should be_a(Array)
    end
    it 'returns instances of the invoice class' do
      fake_customer = collection[0]
      result = fake_customer.invoices[0]
      result.class.should == dbinvoices[0].class
    end
    it 'returns an empty array if no results found' do
      fake_customer.invoices.should == []
    end
    it 'returns an array' do
      customer.invoices.should be_a(Array)
    end
    it 'returns invoices with the customer\'s id' do
      customer.invoices[0].id.should == customer.id
    end
  end

  describe '#transactions' do
    it 'matches invoice ids to a transaction\'s invoice_id' do
      ids = invoices.map { |invoice| invoice.id }
      customer.transactions[0].invoice_id.should == ids[0]
    end
  end

  describe 'extracted_ids' do
    it 'returns ids of invoices' do
      result = customer.extracted_ids
      invoices[0].id.should == result[0]
    end
  end

  describe '#grouped_invoices' do
    it 'returns a hash' do
      customer.grouped_invoices.should be_a(Hash)
    end
    it 'groups by merchant_id' do
      result = customer.grouped_invoices
      result.keys.include?(invoices[0].merchant_id).should == true
    end
  end

  describe '#favorite_merchant_id' do
    it 'returns a merchant ID as a string' do
      customer.favorite_merchant_id.should be_a(String)
    end
    it 'returns the last merchant' do
      pending
    end
  end

  describe '#favorite_merchant' do
    it 'matches an invoice\'s merchant_id to a Merchant id' do
      customer.favorite_merchant.id.should == customer.favorite_merchant_id
    end
    it 'returns a Merchant' do
      customer.favorite_merchant.class.should == SalesEngine::Merchant
    end
  end

end