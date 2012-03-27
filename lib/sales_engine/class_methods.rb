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
            instances = Database.instance.send("#{method_name}")
            result = nil
            instances.each do |id, instance|
              if instance[:self].send("#{attribute}") == query.to_s
                return result = instance[:self]
              end
            end
          end

          define_singleton_method("find_all_by_#{attribute}") do |query|
            instances = Database.instance.send("#{method_name}")
            results = []
            instances.each do |id, instance|
              if instance[:self].send("#{attribute}") == query.to_s
                results << instance[:self]
              end
            end
            results
          end

          define_singleton_method("random") do
            instances = Database.instance.send("#{method_name}")
            num_instances = instances.size
            instances[rand(0...num_instances)][:self]
          end
        end
      end
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
        if DataCleaner.instance.respond_to?("clean_#{key}")
          value = DataCleaner.instance.send("clean_#{key}",value)
        end
        send("#{key}=",value)
      end
    end

  end

  class DataCleaner
    include Singleton

    def clean_id(id)
      id.only_digits
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
end


      # ATTRIBUTES.each do |attribute|
      #   define_singleton_method("all_#{attribute}s") do
      #     self.instance.send("#{attribute}").collect do |i, hash|
      #       self.instance.send("#{attribute}")[i][:self]
      #     end
      #   end
      # end


