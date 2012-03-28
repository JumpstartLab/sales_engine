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
end

