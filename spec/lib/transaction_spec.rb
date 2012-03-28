require 'spec_helper.rb'

describe SalesEngine::Transaction do

  let(:transaction_one) { SalesEngine::Transaction.new(:id => "1", :invoice_id => "1") }
  let(:transaction_two) { SalesEngine::Transaction.new(:id => "2", :invoice_id => "2", :result => "failure") }
  let(:transaction_three) { SalesEngine::Transaction.new(:id => "3", :invoice_id => "2", :result => "success") }
  let(:invoice_one) { SalesEngine::Invoice.new(:id => "1") }
  let(:invoice_two) { SalesEngine::Invoice.new(:id => "2") }

  describe "#invoice" do
    context "when transaction has valid invoice_id" do
      it "return an invoice associated with a given transaction" do
        SalesEngine::Database.instance.transaction_list = [ transaction_one, transaction_two, transaction_three ]
        SalesEngine::Database.instance.invoice_list = [ invoice_one, invoice_two ]
        transaction_one.invoice.should == invoice_one
      end
    end

    context "when transaction has no invoice_id" do
      transaction_four = SalesEngine::Transaction.new(:id => "1", :invoice_id => nil)
      it "returns nil" do
        SalesEngine::Database.instance.invoice_list = [ invoice_one, invoice_two ]
        transaction_four.invoice.should be_nil
      end
    end

    context "when transaction has an invalid invoice_id" do
      transaction_four = SalesEngine::Transaction.new(:id => "1", :invoice_id => "3")
      it "returns nil" do
        SalesEngine::Database.instance.transaction_list = [ transaction_four ]
        SalesEngine::Database.instance.invoice_list = [ invoice_one, invoice_two ]
        transaction_four.invoice.should be_nil
      end
    end
  end
end