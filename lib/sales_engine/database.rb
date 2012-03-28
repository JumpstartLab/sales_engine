require 'singleton'

module SalesEngine
  class Database
    include Singleton
    attr_accessor :transaction_list, :customer_list, :item_list,
                  :merchant_list, :invoice_item_list, :invoice_list,
                  :transaction_id_hash, :customer_id_hash, :item_id_hash,
                  :merchant_id_hash, :invoice_item_id_hash, :invoice_id_hash, :count
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

    def random(object_type)
      random_id = Random.rand(self.send("#{object_type}_list").size)
      self.send("#{object_type}_list").detect do |instance|
        instance.send(:id).to_s == ( random_id + 1 ).to_s
      end
    end
  end
end