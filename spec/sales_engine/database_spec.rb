require 'spec_helper'

describe SalesEngine::Database do

  let(:test_db) {SalesEngine::Database.instance}

  describe "#get_merchants" do

    context "loads a merchant array" do

      it "which is not nil" do
        test_db.get_merchants.should_not == nil
      end

      it "which contains at least one merchant" do
        test_db.get_merchants.count.should >= 1
      end

      it "loaded as many merchants as are in the CSV file"

    end

  end

  describe "#get_items" do
    context "loads an item array" do

      it "which is not nil" do
        test_db.get_items.should_not == nil
      end

      it "which contains at least one item" do
        test_db.get_items.count.should >= 1
      end

      it "loaded as many items as are in the CSV file"
    end
  end

  describe "#get_invoice" do
    context "loads an invoice array" do

      it "which is not nil" do
        test_db.get_invoices.should_not == nil
      end

      it "which contains at least one invoice" do
        test_db.get_invoices.count.should >= 1
      end

      it "loaded as many invoices as are in the CSV file"
    end
  end

end
