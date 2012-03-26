require 'csv'
module SalesEngine
  class CSVManager
    CSV_OPTIONS = {:headers => true, :header_converters => :symbol}

    def self.load(filename)
      file = CSV.open(filename, CSV_OPTIONS)
      results = file.collect { |line| line.to_hash }
      results
    end

    def self.save(record_type)
      save_merchants
      save_customers
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
  end
end
