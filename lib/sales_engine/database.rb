require "class_methods"
class Database 
  ATTRIBUTES = [:transaction, :customer, :item, :invoice_item,
    :merchant, :invoice]
  include Singleton
  include AccessorBuilder

  attr_accessor :invoice, :invoice_item, :customer,
                :merchant, :item, :transaction

  def initialize
    invoice ||= 
    end
    customer ||= Array.new do
      Hash.new do |hash, key|
        if key.to_s.end_with?("s")
          hash[key] = []
        end
      end 
    end
    invoice_item ||= Array.new do
      Hash.new do |hash, key|
        if key.to_s.end_with?("s")
          hash[key] = []
        end
      end 
    end
    merchant ||= Array.new do
      Hash.new do |hash, key|
        if key.to_s.end_with?("s")
          hash[key] = []
        end
      end 
    end
    transaction ||= Array.new do
      Hash.new do |hash, key|
        if key.to_s.end_with?("s")
          hash[key] = []
        end
      end 
    end
    item ||= Array.new do
      Hash.new do |hash, key|
        if key.to_s.end_with?("s")
          hash[key] = []
        end
      end 
    end
    
    ATTRIBUTES.each do |attribute|
      send("#{attribute}=", Array.new)
    end
  end

  def update
    threads = []
    ATTRIBUTES.each do |attribute|
      threads << Thread.new do
        attr_array = send("#{attribute}")
        attr_array.each do |instance|
          instance.send("update")
        end
      end
    end 
    threads.each do |thread|
      thread.join
    end
  end
end