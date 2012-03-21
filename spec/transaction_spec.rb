require './spec/spec_helper.rb'

describe Transaction do

  let(:transaction_one) { Transaction.new(:id => "1", :invoice_id => "1") }
  let(:transaction_two) { Transaction.new(:id => "2", :invoice_id => "2", :status => "failure") }
  let(:transaction_three) { Transaction.new(:id => "3", :invoice_id => "2", :status => "success") }
  let(:invoice_one) { Invoice.new(:id => "1") }
  let(:invoice_two) { Invoice.new(:id => "2") }

  describe "#invoice" do
    it "return an invoice associated with a given transaction" do
      Transaction.transaction_list = [ transaction_one, transaction_two, transaction_three ]
      Invoice.invoice_list = [ invoice_one, invoice_two ]
      transaction_one.invoice.should == invoice_one
    end

  end
end