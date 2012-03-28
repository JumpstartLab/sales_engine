require 'singleton'

module SalesEngine
  class Database
    include Singleton
    attr_accessor :transaction_list, :customer_list, :item_list,
                  :merchant_list, :invoice_item_list, :invoice_list
    def initialize
      self.transaction_list = []
      self.invoice_list = []
    end

    def find(object_type, attribute, param)
      self.send("#{object_type}_list").detect do |instance|
        instance.send(attribute.to_sym).to_s.downcase == param.to_s.downcase
      end
    end

    def find_all(object_type, attribute, param)
      self.send("#{object_type}_list").select do |instance|
        instance.send(attribute.to_sym).to_s.downcase == param.to_s.downcase
      end
    end
  end
end