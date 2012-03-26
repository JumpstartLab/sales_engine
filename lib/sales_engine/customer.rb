module SalesEngine
  class Customer
    extend Searchable
    attr_accessor :first_name, :last_name, :id, :raw_csv

    def self.records
      @customers ||= get_customers
    end

    def self.csv_headers
      @csv_headers
    end

    def self.csv_headers=(value)
      @csv_headers=(value)
    end

    def self.get_customers
      CSVManager.load('data/customers.csv').collect do |record|
        Customer.new(record)
      end
    end

    def initialize(raw_line)
      self.first_name = raw_line[:first_name]
      self.last_name = raw_line[:last_name]
      self.id = raw_line[:id].to_i
      self.raw_csv = raw_line.values
      Customer.csv_headers ||= raw_line.keys
    end

    def invoices
      @invoices ||= SalesEngine::Invoice.find_all_by_customer_id(self.id)
    end

    def transactions
      invoices.flat_map(&:transactions)
    end

    def favorite_merchant
      inv = invoices.group_by { |i| i.merchant_id }
      fm_id = inv.sort_by{|i| i.last.size}.last.first
      SalesEngine::Merchant.find_by_id(fm_id)
    end
  end
end