require 'spec_helper.rb'

describe SalesEngine::CsvLoader do
  describe SalesEngine::CsvLoader do
    it "loads transactions into database" do
      SalesEngine::CsvLoader.load_transactions
      SalesEngine::Database.instance.transaction_list.count == 4985
    end
  end

  describe ".load_customers" do
    it "loads transactions into database" do
      SalesEngine::CsvLoader.load_customers
      SalesEngine::Database.instance.customer_list.count == 1000
    end
  end

  describe ".load_merchants" do
    it "loads transactions into database" do
      SalesEngine::CsvLoader.load_merchants
      SalesEngine::Database.instance.merchant_list.count == 100
    end
  end

  describe ".load_invoice_items" do
    it "loads transactions into database" do
      SalesEngine::CsvLoader.load_invoice_items
      SalesEngine::Database.instance.invoice_item_list.count == 22264
    end
  end

  describe ".load_invoices" do
  it "loads transactions into database" do
    SalesEngine::CsvLoader.load_invoices
    SalesEngine::Database.instance.invoice_list.count == 4985
    end
  end
end