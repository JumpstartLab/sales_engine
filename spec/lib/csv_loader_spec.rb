require 'spec_helper.rb'

describe SalesEngine::CsvLoader do
  describe SalesEngine::CsvLoader do
    it "loads transactions into database" do
      SalesEngine::CsvLoader.load('transaction')
      SalesEngine::Database.instance.transaction_list.count == 4985
    end
  end

  describe ".load_customers" do
    it "loads customeres into database" do
      SalesEngine::CsvLoader.load('customer')
      SalesEngine::Database.instance.customer_list.count == 1000
    end
  end

  describe ".load_merchants" do
    it "loads merchants into database" do
      SalesEngine::CsvLoader.load('merchant')
      SalesEngine::Database.instance.merchant_list.count == 100
    end
  end

  describe ".load_invoice_items" do
    it "loads invoice items into database" do
      SalesEngine::CsvLoader.load('invoice_item')
      SalesEngine::Database.instance.invoice_item_list.count == 22264
    end
  end

  describe ".load_invoices" do
  it "loads invoices into database" do
    SalesEngine::CsvLoader.load('invoice')
    SalesEngine::Database.instance.invoice_list.count == 4985
    end
  end
end