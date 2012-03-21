require './database'
require './spec/spec_helper'

describe Database do
  describe '#initialize' do
    let(:database) { Database.instance }
    context "when loading database" do 
      it "sets customers" do
        database.customers.any?.should be_true
      end
      it "sets invoices" do
        database.invoices.any?.should be_true
      end
      it "sets invoiceitems" do
        database.invoiceitems.any?.should be_true
      end
      it "sets items" do
        database.items.any?.should be_true
      end
      it "sets merchants" do
        database.merchants.any?.should be_true
      end
      it "sets transactions" do
        database.transactions.any?.should be_true
      end
    end
  end
end