require 'singleton'
require 'pp'

class String
  def only_digits
    self.gsub(/\D/,"")
  end
end

module SalesEngine
  module SearchMethods
    def self.extended(base)
      base.class_eval do
        class_name = base.to_s.gsub(/\w+::/, "")
        if class_name == "InvoiceItem"
          method_name = "invoice_item"
        else
          method_name = "#{class_name.downcase}"
        end
        self::ATTRIBUTES.each do |attribute|
          define_singleton_method("find_by_#{attribute}") do |query|
            instances = Database.instance.send("all_#{method_name}s")
            result = nil
            instances.each do |instance|
              if instance.send("#{attribute}") == query
                result = instance
              end
            end
            result
          end

          define_singleton_method("find_all_by_#{attribute}") do |query|
            instances = Database.instance.send("all_#{method_name}s")
            results = []
            instances.each do |instance|
              if instance.send("#{attribute}") == query
                results << instance
              end
            end
            results
          end

          define_singleton_method("random") do
            Database.instance.send("all_#{method_name}s").sample
          end
        end
      end
    end
  end

  class DataCleaner
    include Singleton

    def clean_id(id)
      id.only_digits.to_i
    end

    def clean_unit_price(unit_price)
      BigDecimal(unit_price.to_s)/100
    end

    def clean_name(name)
      name.to_s
    end

    def clean_updated_at(date)
      Date.parse(date)
    end

    def clean_created_at(date)
      Date.parse(date)
    end

    def clean_merchant_id(id)
      clean_id(id)
    end

    def clean_item_id(id)
      clean_id(id)
    end

    def clean_invoice_id(id)
      clean_id(id)
    end

    def clean_invoice_item_id(id)
      clean_id(id)
    end

    def clean_transaction_id(id)
      clean_id(id)
    end

    def clean_customer_id(id)
      clean_id(id)
    end

    def clean_quantity(quantity)
      quantity.to_i
    end
  end

  module AccessorBuilder
      def self.included(base)
        base.class_eval do
          self::ATTRIBUTES.each do |attribute|
            attr_accessor attribute
          end
        end
      end

      def define_attributes (attributes)
        attributes.each do |key, value|
          if DataCleaner.instance.respond_to?("clean_#{key.to_s}")
            value = DataCleaner.instance.send("clean_#{key.to_s}",value)
          end
          send("#{key}=",value)
        end
      end
  end

  class Database
    ATTRIBUTES = [:transaction, :customer, :item, :invoice_item,
      :merchant, :invoice, :all_transactions, :all_customers, :all_items,
      :all_invoice_items, :all_merchants, :all_invoices]
    HASHES = [:transaction, :customer, :item, :invoice_item,
        :merchant, :invoice,]
    ARRAYS = [:all_transactions, :all_customers, :all_items,
          :all_invoice_items, :all_merchants, :all_invoices]
    include Singleton
    include AccessorBuilder

    class_eval do
      def initialize
        HASHES.each do |hash|
          hash_init = Hash.new do |hash,key|
            hash[key] = Hash.new do |hash, key|
              if key.to_s.end_with?("s")
                hash[key] = []
              end
            end
          end
          send("#{hash}=", hash_init)
        end
        ARRAYS.each do |array|
         send("#{array}=", [])
        end
      end
    end
  end

  module invoice_ish_initializers
    def initialize_part_un(attributes)
      define_attributes(attributes)
      Database.instance.send(self.class)[id][:self] = self
      Database.instance.send("all_#{self.class}")[id-1] = self
    end
  end

end
