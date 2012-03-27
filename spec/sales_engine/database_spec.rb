require 'spec_helper'

describe SalesEngine::Database do
  let(:se) { SalesEngine::Database.instance }

  before(:each) do
    se.clear_all_data
  end

  describe "#load_merchants_data" do
    it "reads in merchant data from a file & stores the result as a merchant master list" do
      se.load_merchants_data('./data/test/merchants.csv')
      se.merchants.count.should == 3
    end
  end

  describe "#load_items_data" do
    it "reads in item data from a file & stores the result as an item master list" do
      se.load_items_data('./data/test/items.csv')
      se.items.count.should == 2
    end
  end

  describe "#load_invoices_data" do
    it "reads in invoice data from a file & stores the result as an invoice master list" do
      se.load_invoices_data('./data/test/invoices.csv')
      se.invoices.count.should == 4
    end
  end

  describe "#load_customers_data" do
    it "reads in customer data from a file & stores the result as a customer master list" do
      se.load_customers_data('./data/test/customers.csv')
      se.customers.count.should == 4
    end
  end

  describe "#load_invoice_items_data" do
    it "reads in invoice items data from a file & stores the result as an invoice item master list" do
      se.load_invoice_items_data('./data/test/invoice_items.csv')
      se.invoiceitems.count.should == 4
    end
  end

  describe "#load_transactions_data" do
    it "reads in transactions items data from a file & stores the result as a transactions master list" do
      se.load_transactions_data('./data/test/transactions.csv')
      se.transactions.count.should == 4
    end
  end

  describe "#add_to_list" do
    it "allows you to add a new object to the appropriate master list" do
      se.add_to_list(SalesEngine::Merchant.new)
      se.merchants.count.should == 1
    end
  end

  describe "#export_data" do
    
  end
end