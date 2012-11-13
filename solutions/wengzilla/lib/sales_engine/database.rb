require 'singleton'

module SalesEngine
  class Database
    include Singleton
    attr_accessor :transaction_list, :customer_list, :item_list,
                  :merchant_list, :invoice_item_list, :invoice_list,
                  :transaction_id_hash, :customer_id_hash, :item_id_hash,
                  :merchant_id_hash, :invoice_item_id_hash, :invoice_id_hash,
                  :count
    def initialize
      self.transaction_list = []
      self.customer_list = []
      self.item_list = []
      self.merchant_list = []
      self.invoice_item_list = []
      self.invoice_list = []
      self.transaction_id_hash = {}
      self.customer_id_hash = {}
      self.item_id_hash = {}
      self.merchant_id_hash = {}
      self.invoice_item_id_hash = {}
      self.invoice_id_hash = {}
    end

    def find(object_type, attribute, param)
      if attribute == "id"
        find_by_id( object_type, param )
      else
        self.send("#{object_type}_list").detect do |instance|
          instance.send(attribute.to_sym).to_s.downcase == param.to_s.downcase
        end
      end
    end

    def find_all(object_type, attribute, param)
      self.send("#{object_type}_list").select do |instance|
        instance.send(attribute.to_sym).to_s.downcase == param.to_s.downcase
      end
    end

    def find_by_id(object_type, param)
      self.send("#{object_type}_id_hash".to_sym)[param]
    end

    def random(object_type)
      object_array = self.send("#{object_type}_list")
      random_id = Random.rand(object_array.size)
      object_array.detect do |instance|
        instance.send(:id).to_s == ( random_id + 1 ).to_s
      end
    end
  end
end