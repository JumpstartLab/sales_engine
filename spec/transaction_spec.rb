require './spec/spec_helper'

describe SalesEngine::Transaction do
  describe ".get_transactions" do
    before(:all) { SalesEngine::Transaction.get_transactions }
    it "stores records from transaction.csv in @@records" do
      SalesEngine::Transaction.records.map(&:class).uniq.should == [SalesEngine::Transaction]
    end
    {id: 1, invoice_id: 1, credit_card_number: "4068631943231473", credit_card_expiration_date: nil, result: "success"}.each do |attribute, value|
      it "records #{attribute}" do
        SalesEngine::Transaction.records.first.send(attribute).should == value
      end
    end
  end

  context "instance methods" do
    let(:transaction) { SalesEngine::Transaction.find_by_id(1) }
    describe "#invoice" do
      it "returns an invoice" do
        transaction.invoice.should be_a(SalesEngine::Invoice)
      end
      it "returns its invoice" do
        transaction.invoice.should == SalesEngine::Invoice.find_by_id(1)
      end
    end
  end
end

#id,invoice_id,credit_card_number,credit_card_expiration_date,result,created_at,updated_at
#1,1,4068631943231473,,success,2012-02-26 20:56:56 UTC,2012-02-26 20:56:56 UTC