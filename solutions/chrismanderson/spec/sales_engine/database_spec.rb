require 'spec_helper'

describe SalesEngine::Database do

  let(:test_db) {SalesEngine::Database.instance}

  describe "#merchants" do

    context "loads a merchant array" do

      it "which is not nil" do
        test_db.merchants.should_not == nil
      end

      it "which contains at least one merchant" do
        test_db.merchants.count.should >= 1
      end

    end

  end

  describe "#tems" do
    context "loads an item array" do

      it "which is not nil" do
        test_db.items.should_not == nil
      end

      it "which contains at least one item" do
        test_db.items.count.should >= 1
      end

    end
  end

  describe "#invoices" do
    context "loads an invoice array" do

      it "which is not nil" do
        test_db.invoices.should_not == nil
      end

      it "which contains at least one invoice" do
        test_db.invoices.count.should >= 1
      end

    end
  end

  describe "#invoice_items" do
    context "loads an invoice_item array" do
      it "which is not nil" do
        test_db.invoices.should_not == nil
      end

      it "which contains at least one invoice_item" do
        test_db.invoices.count.should >= 1
      end

    end
  end

  describe "#customers" do
    context "loads an array of customers" do
      it "which is not nil" do
        test_db.customers.should_not == nil
      end

      it "which contains at least one customer" do
        test_db.customers.count.should >= 1
      end

    end
  end

  describe "#transactions" do
    context "loads an array of transactions" do
      it "which is not nil" do
        test_db.customers.should_not == nil
      end

      it "which contains at least one customer" do
        test_db.customers.count.should >= 1
      end

    end
  end

end
