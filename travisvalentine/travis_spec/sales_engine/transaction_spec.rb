require 'spec_helper'

describe SalesEngine::Transaction do
  param = ({:id => 1, :invoice_id => 1,
                      :credit_card_number => "4068631943231473",
                      :credit_card_expiration_date => nil,
                      :result => "success",
                      :created_at => "2012-02-26 20:56:56 UTC",
                      :updated_at => "2012-02-26 20:56:56 UTC"})

  let(:transaction) { SalesEngine::Transaction.new(param) }
  describe '.initialize' do
    context "when instantiating a new invoice" do
      it 'receives a hash as a param' do
        param.should be_a(Hash)
      end
      [:id, :invoice_id, :credit_card_number, :result,
       :created_at, :updated_at].each do |method|
        it "sets the invoice's attribute #{method}
        with the method #{method}" do
          transaction.send(method).should_not be_nil
        end
      end
      it 'returns nil for credit_card_expiration_date' do
        transaction.credit_card_expiration_date.should be_nil
      end
    end
  end

  let(:transactions) {SalesEngine::Database.instance.transactions}
  describe '.collection' do
    it 'creates an array' do
      transactions.should be_a(Array)
    end
    it 'contains instances of the transaction class' do
      transactions.first.class.should == transaction.class
    end
    it 'is not empty' do
      transactions.should_not be_empty
    end
  end

  describe '.database' do
    it 'proxies to Database' do
      SalesEngine::Database.should_receive(:instance)
      SalesEngine::Transaction.database
    end
  end

  describe '#database' do
    it 'proxies to Database' do
      SalesEngine::Database.should_receive(:instance)
      transaction.database
    end
  end

  describe '#database=' do
    it 'proxies to Database' do
      SalesEngine::Database.should_receive(:instance)
      transaction.database
    end
  end

  describe '.invoice' do
    it 'returns an invoice' do
      an_invoice = transactions[0].invoice
      an_invoice.class.should == SalesEngine::Invoice
    end
    it 'matches an invoice to the instansiated
        transaction\'s invoice_id'  do
      an_invoice = transactions[0].invoice
      a_transaction = transactions[0]
      an_invoice.id.should == a_transaction.invoice_id
    end
  end

  describe '#successful?' do
    context 'for an instance of transaction' do
      it 'should return success for transaction.result' do
        transaction.result.should == "success"
      end
    end
  end

  describe '.find_all_by_date(date)' do
    it '' do
      pending
    end
  end

  describe '.successful_transactions' do
    it '' do
      pending
    end
  end

  describe '#find_by_date(date)' do
    it '' do
      pending
    end
  end
end