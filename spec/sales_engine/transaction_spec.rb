require 'spec_helper'

describe SalesEngine::Transaction do
  param = ({:id => 1, :invoice_id => 1, 
                      :credit_card_number => "4068631943231473", 
                      :credit_card_expiration_date => nil, 
                      :result => "success", :created_at => "2012-02-26 20:56:56 UTC", 
                      :updated_at => "2012-02-26 20:56:56 UTC"})

  let(:transaction) { SalesEngine::Transaction.new(param) }           
  describe '.initialize' do
    context "when instantiating a new invoice" do
      it 'receives a hash as a param' do
        param.should be_a(Hash)
      end
      [:id, :invoice_id, :credit_card_number, :result,
       :created_at, :updated_at].each do |method|
        it "sets the invoice's attribute #{method} with the method #{method}" do
          transaction.send(method).should_not be_nil
        end
      end
      it 'returns nil for credit_card_expiration_date' do
        transaction.credit_card_expiration_date.should be_nil
      end
    end
  end

  let(:all_transactions) {SalesEngine::Database.instance.transactions}
  describe '.invoice' do
    it 'returns an invoice' do
      an_invoice = all_transactions[0].invoice
      an_invoice.class.should == SalesEngine::Invoice
    end
    it 'matches an invoice to the instansiated
        transaction\'s invoice_id'  do
      an_invoice = all_transactions[0].invoice
      a_transaction = all_transactions[0]
      an_invoice.id.should == a_transaction.invoice_id
    end
  end
end