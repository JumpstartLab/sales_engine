require 'spec_helper'

describe SalesEngine::Transaction do

  context "Searching" do
    describe ".random" do
      it "usually returns different things on subsequent calls" do
        transaction_one = SalesEngine::Transaction.random
        10.times do
          transaction_two = SalesEngine::Transaction.random
          break if transaction_one.id != transaction_two.id
        end

        transaction_one.id.should_not == transaction_two.id
      end
    end

    describe ".find_by_credit_card_number" do
      transaction = SalesEngine::Transaction.find_by_credit_card_number "4634664005836219"
      transaction.id.should == 5536
    end

    describe ".find_all_by_result" do
      transactions = SalesEngine::Transaction.find_all_by_result "success"
      transactions.should have(4648).transactions
    end
  end

  context "Relationships" do
    let(:transaction) { SalesEngine::Transaction.find_by_id 1138 }

    describe "#invoice" do
      it "exists" do
        invoice_customer = SalesEngine::Customer.find_by_id 192
        transaction.invoice.customer.first_name.should == invoice_customer.first_name
      end
    end

  end

  context "Business Intelligence" do

  end
end

