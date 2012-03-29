require 'sales_engine/database'
require 'sales_engine/find'

module SalesEngine
  class Transaction
    extend Find

    attr_accessor :id, :invoice_id, :credit_card_number,
                  :credit_card_expiration_date, :result,
                  :created_at, :updated_at

    def initialize(atts={})
      self.id                           = atts[:id].to_i
      self.invoice_id                   = atts[:invoice_id].to_i
      self.credit_card_number           = atts[:credit_card_number]
      self.credit_card_expiration_date  = atts[:credit_card_expiration_date]
      self.result                       = atts[:result]
      self.created_at                   = atts[:updated_at]
    end

    class << self
      attributes = [:id, :invoice_id, :credit_card_number,
                  :credit_card_expiration_date, :result,
                  :created_at, :updated_at, :date]
      attributes.each do |attribute|
        define_method "find_by_#{attribute}" do |input|
          find_transactions(attribute, input)
        end
        define_method "find_all_by_#{attribute}" do |input|
          find_all_transactions(attribute, input)
        end
      end
    end

    def successful?
      @result == "success"
    end

    def date
      self.created_at.split[0]
    end

    def self.random
      Database.instance.transactions.sample
    end

    def invoice
      SalesEngine::Invoice.find_by_id(self.invoice_id)
    end
  end
end