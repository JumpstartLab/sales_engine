require './lib/sales_engine/database'
require './lib/sales_engine/find'
#require './invoice'

module SalesEngine
  class Transaction
    extend Find
    # id,invoice_id,credit_card_number,credit_card_expiration_date,result,created_at,updated_at

    attr_accessor :id, :invoice_id, :credit_card_number,
                  :credit_card_expiration_date, :result,
                  :created_at, :updated_at

    def initialize(attributes={})
      self.id                           = attributes[:id]
      self.invoice_id                   = attributes[:invoice_id]
      self.credit_card_number           = attributes[:credit_card_number]
      self.credit_card_expiration_date  = attributes[:credit_card_expiration_date]
      self.result                       = attributes[:result]
      self.created_at                   = attributes[:updated_at]
    end

    class << self
      attributes = [:id, :invoice_id, :credit_card_number,
                  :credit_card_expiration_date, :result,
                  :created_at, :updated_at]
      attributes.each do |attribute|
        define_method "find_by_#{attribute}" do |input|
          find_transactions(attribute, input.to_s)
        end
        define_method "find_all_by_#{attribute}" do |input|
          find_all_transactions(attribute, input.to_s)
        end
      end
    end

    def date
      self.created_at.split[0]
    end

    def self.random
      # just using for testing purposes
      Database.instance.transactions.sample
    end

    def invoice
      #invoice returns an instance of Invoice associated with this object
      Database.instance.invoices.find do |i|
        i.send(:id) == self.invoice_id
      end
    end
  end
end