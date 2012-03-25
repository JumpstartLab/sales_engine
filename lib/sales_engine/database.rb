require "class_methods"
class Database 
  ATTRIBUTES = [:transaction, :customer, :item, :invoice_item,
    :merchant, :invoice]
  include Singleton
  include AccessorBuilder

  def initialize
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