require 'csv'
require 'sales_engine/searchable'
require 'sales_engine/randomize'

module SalesEngine
  class Customer
    extend Randomize
    extend Searchable

    attr_accessor :id, :first_name, :last_name, :created_at,
                  :updated_at

    def initialize(attributes)
      self.id         = attributes[:id].to_i
      self.first_name = attributes[:first_name]
      self.last_name  = attributes[:last_name]
      self.created_at = Date.parse(attributes[:created_at])
      self.updated_at = Date.parse(attributes[:updated_at])
    end

    class << self
      [:id, :first_name, :last_name, :created_at,
       :updated_at].each do |attribute|
        define_method "find_by_#{attribute}" {find_by_(attribute, input)}
        define_method "find_all_by_#{attribute}" {find_all_by_(attribute,input)}
      end
    end

    def self.collection
      database.customers
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

    def invoices
      SalesEngine::Invoice.find_all_by_customer_id(self.id)
    end

    def transactions
      database.transactions.select do |transaction|
        extracted_ids.include? transaction.invoice_id
      end
    end

    def extracted_ids
      invoices.map { |invoice| invoice.id }
    end

    def grouped_invoices
      invoices.group_by { |invoice| invoice.merchant_id }
    end

    def favorite_merchant_id
      grouped_invoices.keys.last
    end

    def favorite_merchant
      SalesEngine::Merchant.find_by_id(favorite_merchant_id)
    end

    def pending_invoices
      invoices.reject do |invoice|
        invoice.transactions.map(&:result).include?("success")
      end
    end

    def has_pending_invoices?(merch_class_id)
      result = pending_invoices.select do |invoice|
        invoice.merchant_id == merch_class_id
      end
      result.any?
    end

  end
end