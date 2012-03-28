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
      self.id         = attributes[:id]
      self.first_name = attributes[:first_name]
      self.last_name  = attributes[:last_name]
      self.created_at = attributes[:created_at]
      self.updated_at = attributes[:updated_at]
    end

    class << self
      [:id, :first_name, :last_name, :created_at,
       :updated_at].each do |attribute|
        define_method "find_by_#{attribute}" do |input|
          find_by_(attribute, input)
        end
      end

      [:id, :first_name, :last_name, :created_at,
       :updated_at].each do |attribute|
        define_method "find_all_by_#{attribute}" do |input|
          find_all_by_(attribute, input)
        end
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
      database.invoices.select { |invoice| invoice.customer_id == self.id }
    end

    def transactions
      database.transactions.select do |transaction|
        extracted_ids.include? transaction.invoice_id
      end
    end

    def extracted_ids
      matched_invoices.map { |invoice| invoice.id }
    end

    def matched_invoices
      SalesEngine::Invoice.find_all_by_customer_id(self.id)
    end

    def favorite_merchant
      SalesEngine::Merchant.find_by_id(fav_merch_id)
    end

    def fav_merch_id
      result_hash = matched_invoices.group_by { |invoice| invoice.merchant_id }
      result_hash.keys.last
    end

  end
end