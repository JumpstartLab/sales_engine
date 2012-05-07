module SalesEngine
  class Transaction
    extend Randomize
    extend Searchable

    attr_accessor :id, :invoice_id, :credit_card_number,
                  :credit_card_expiration_date, :result,
                  :created_at, :updated_at

    def initialize(attributes)
      self.id         = attributes[:id].to_i
      self.invoice_id = attributes[:invoice_id].to_i
      self.credit_card_number = attributes[:credit_card_number]
      self.credit_card_expiration_date =
        attributes[:credit_card_expiration_date]
      self.result     = attributes[:result]
      self.created_at = Date.parse(attributes[:created_at])
      self.updated_at = Date.parse(attributes[:updated_at])
    end

    class << self
      [:id, :invoice_id, :credit_card_number,
       :credit_card_expiration_date, :result,
       :created_at, :updated_at].each do |attribute|
        define_method "find_by_#{attribute}" {find_by_(attribute, input)}
        define_method "find_all_by_#{attribute}" {find_all_by_(attribute,input)}
      end
    end

    def self.create(invoice_id, attributes={})
      t = Transaction.new(
        :id => database.transactions.count + 1,
        :invoice_id => invoice_id,
        :credit_card_number => attributes[:credit_card_number],
        :credit_card_expiration_date => attributes[:credit_card_expiration],
        :result => attributes[:result],
        :created_at => Time.now.to_s,
        :updated_at => Time.now.to_s )

      SalesEngine::Database.instance.transactions << t

      t
    end

    def self.collection
      database.transactions
    end

    def self.database
      SalesEngine::Database.instance
    end

    def database
      @database ||= SalesEngine::Database.instance
    end

    def database=(input)
      @database = input
    end

    def invoice
      matched_invoices = SalesEngine::Invoice.find_all_by_id(self.invoice_id)
      matched_invoices[0]
    end

    def successful?
      result == "success"
    end

    def self.find_all_by_date(date)
      successful_transactions.select{
        |transaction| transaction.created_at == date
      }
    end

    def self.successful_transactions
      collection.select{ |t| t.result == "success" }
    end

    def find_by_date(date)
      collection.select{
        |transaction| transaction.successful?.created_at == date
      }
    end

  end
end