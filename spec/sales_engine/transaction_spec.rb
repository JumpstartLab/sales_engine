require 'spec_helper'

describe SalesEngine::Transaction do
  let(:transaction) {SalesEngine::Transaction.new({:id => 1, :invoice_id => "2", :credit_card_number => "", :credit_card_expiration_date => "number", :result => "text", :created_at => "time", :updated_at => "time"})}
  describe '.initialize' do
    context "when instantiating a new transaction" do    
      it "sets id" do
        transaction.id.should == 1
      end
    end
  end

  let(:collection) {SalesEngine::Database.instance.transactions}
  describe '.collection' do
    it 'creates an array' do
      collection.should be_a(Array)
    end
    it 'contains instances of the item class' do
      collection.first.class.should == transaction.class
    end
    it 'is not nil' do
      collection.should_not be_nil
    end
  end

  describe '.invoice' do
    it 'returns an invoice' do
      transaction.invoice.class.should == SalesEngine::Invoice
    end
    it 'matches an invoice to the instansiated
        transaction\'s invoice_id'  do
      transaction.invoice.id.should == transaction.invoice_id
    end
  end
end