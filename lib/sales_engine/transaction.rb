module SalesEngine
  class Transaction
    extend Searchable
    attr_accessor :id, :invoice_id, :credit_card_number
    attr_accessor :credit_card_expiration_date, :result
    # attr_accessor :raw_csv

    def self.records
      @transactions ||= get_transactions
    end

    def self.get_transactions
      CSVManager.load('data/transactions.csv').collect do |record|
        Transaction.new(record)
      end
    end

    # def self.csv_headers
    #   @csv_headers
    # end

    # def self.csv_headers=(value)
    #   @csv_headers=(value)
    # end

    def self.create(params)
      t = self.new(params)
      t.id = records.last.id + 1
      records << t
    end

    def initialize(raw_line)
      self.id = raw_line[:id].to_i
      self.invoice_id = raw_line[:invoice_id].to_i
      self.credit_card_number = raw_line[:credit_card_number]
      self.credit_card_expiration_date = raw_line[:credit_card_expiration_date]
      self.result = raw_line[:result]
      # self.raw_csv = raw_line.values
      # Transaction.csv_headers ||= raw_line.keys
    end

    def invoice
      @invoice ||= SalesEngine::Invoice.find_by_id(self.invoice_id)
    end
  end
end