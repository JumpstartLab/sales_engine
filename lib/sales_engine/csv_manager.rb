require 'csv'
module SalesEngine
  class CSVManager
    CSV_OPTIONS = {:headers => true, :header_converters => :symbol}

    def self.load(filename)
      file = CSV.open(filename, CSV_OPTIONS)
      results = file.collect { |line| line.to_hash }
      results
    end

    def self.save
      save_merchants
      save_customers
      save_invoices
      save_invoice_items
      save_transactions
      save_items
    end

    def self.save_merchants
      file = CSV.open('data/merchant_output.csv', "w") do |output|
        output <<  SalesEngine::Merchant.csv_headers
        SalesEngine::Merchant.all.each do |row|
          output << row.raw_csv
        end
      end
    end
    def self.save_customers
      file = CSV.open('data/customer_output.csv', "w") do |output|
        output <<  SalesEngine::Customer.csv_headers
        SalesEngine::Customer.all.each do |row|
          output << row.raw_csv
        end
      end
    end
    def self.save_invoices
      file = CSV.open('data/invoice_output.csv', "w") do |output|
        output <<  SalesEngine::Invoice.csv_headers
        SalesEngine::Invoice.all.each do |row|
          output << row.raw_csv
        end
      end
    end
    def self.save_invoice_items
      file = CSV.open('data/invoice_item_output.csv', "w") do |output|
        output <<  SalesEngine::InvoiceItem.csv_headers
        SalesEngine::InvoiceItem.all.each do |row|
          output << row.raw_csv
        end
      end
    end
    def self.save_items
      file = CSV.open('data/item_output.csv', "w") do |output|
        output <<  SalesEngine::Item.csv_headers
        SalesEngine::Item.all.each do |row|
          output << row.raw_csv
        end
      end
    end
    def self.save_transactions
      file = CSV.open('data/transaction_output.csv', "w") do |output|
        output <<  SalesEngine::Transaction.csv_headers
        SalesEngine::Transaction.all.each do |row|
          output << row.raw_csv
        end
      end
    end
  end
end
