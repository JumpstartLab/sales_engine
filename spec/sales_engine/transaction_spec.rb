require 'spec_helper'

describe SalesEngine::Transaction do

  let(:test_transaction) { Fabricate(:transaction) }

  describe "#invoice" do
    context "returns an invoice associated with this transaction" do
      it "returns an invoice" do
        test_transaction.invoice.is_a?(SalesEngine::Invoice).should == true
      end

      it "returns an invoice associated with this transaction" do
        test_transaction.invoice.id.should == test_transaction.invoice_id
      end
    end
  end

end


# describe Transaction do
# end