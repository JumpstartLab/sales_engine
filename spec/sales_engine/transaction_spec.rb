require 'spec_helper'

describe SalesEngine::Transaction do

  test_attr = {:id => "2", :invoice_id => "2",
    :credit_card_number => "4177816490204479",
    :credit_card_expiration_date => "",
    :result => "success",
    :created_at => "2012-02-26 20:56:56 UTC",
    :updated_at => "2012-02-26 20:56:56 UTC" }

  let(:test_transaction){SalesEngine::Transaction.new(test_attr)}

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