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
            instances_of_class = Database.instance.send(method_name)
            instances_of_class.each do |instance|
              if instance.send("#{attribute}") == query
                return instance
              end
            end
            nil
          end

          define_singleton_method("find_all_by_#{attribute}") do |query|
            instances_of_class = Database.instance.send(method_name)
            instances_of_class.select do |instance|
              instance.send("#{attribute}") == query
            end
            []
          end

          define_singleton_method("random") do
            instances_of_class = Database.instance.send(method_name)
            num_instances = instances_of_class.count
            instances_of_class[rand(0...num_instances)]
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
    ATTRIBUTES = [:customer, :item, :invoice_item,
      :merchant, :transaction, :invoice]
      include Singleton
      include AccessorBuilder

      def initialize
        ATTRIBUTES.each do |attribute|
          send("#{attribute}=", Array.new)
        end
      end
    end
  end