require 'spec_helper'

describe Transaction do
  context "Searching" do
    describe ".random" do
      it "usually returns different
          things on subsequent calls" do
        transaction_one = Transaction.random
        10.times do
          transaction_two = Transaction.random
          break if transaction_one != transaction_two
        end

        transaction_one.should_not == transaction_two
      end
    end

    describe ".find_by_credit_card_number" do
      transaction = Transaction.find_by_credit_card_number "4901931478327757"
      transaction.id.should == 2106
    end

    describe ".find_all_by_result" do
      transactions = Transaction.find_all_by_result "success"
      transactions.should have(4871).transactions
    end
  end

  context "Relationships" do
    let(:transaction) { Transaction.find_by_id 1138 }

    describe "#invoice" do
      it "exists" do
        invoice_customer = Customer.find_by_id 234
        transaction.invoice.customer.first_name.should ==
          invoice_customer.first_name
      end
    end

  end

  context "Business Intelligence" do

  end
end