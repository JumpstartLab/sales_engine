require 'spec_helper'

describe SalesEngine::Transaction do
  describe 'initialize' do
    context "when instantiating a new transaction" do
    let(:transaction) {SalesEngine::Transaction.new({:id => 1, :invoice_id => "2", :credit_card_number => "", :credit_card_expiration_date => "number", :result => "text", :created_at => "time", :updated_at => "time"})}
      it "sets id" do
        transaction.id.should == 1
      end
    end
  end
  
end