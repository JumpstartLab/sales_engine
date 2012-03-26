require './spec/spec_helper'

describe SalesEngine::Transaction do
  let(:se) { SalesEngine::Database.instance}
  let(:invoice_1) { Fabricate(:invoice) }
  let(:invoice_2) { Fabricate(:invoice) }
  let(:transaction_1) { Fabricate(:transaction, :invoice_id => invoice_1.id) }
  let(:transaction_2) { Fabricate(:transaction, :invoice_id => invoice_2.id) }

  before(:each) do
    se.clear_all_data
    se.add_to_list(invoice_1)
    se.add_to_list(invoice_2)
    se.add_to_list(transaction_1)
    se.add_to_list(transaction_2)
  end
  
  describe "#invoice" do
    it "returns an instance of Invoice associated with this object" do
      transaction_2.invoice.should == invoice_2
    end
  end
end