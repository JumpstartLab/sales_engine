require 'singleton'
module SearchMethods
  def self.extended(base)
    base.class_eval do
      self::ATTRIBUTES.each do |attribute|

        define_singleton_method("find_by_#{attribute}") do |query|
          instances_of_class = Database.instance.send(base.to_s.downcase)
          instances_of_class.each do |instance|
            if instance.send("#{attribute}") == query
              return instance
            end
          end
          nil
        end

        define_singleton_method("find_all_by_#{attribute}") do |query|
          instances_of_class = Database.instance.send(base.to_s.downcase)
          instances_of_class.select do |instance|
            instance.send("#{attribute}") == query
          end
        end

        define_singleton_method("random") do
          instances_of_class = Database.instance.send("#{base.to_s.downcase}")
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
      send("#{key}=",value)
    end
  end

  def headers
    ATTRIBUTES
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

