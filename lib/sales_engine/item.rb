module SalesEngine
  class Item
    #extend SalesEngine::Search
    attr_accessor :id,
                  :name,
                  :description,
                  :unit_price,
                  :merchant_id,
                  :created_at,
                  :updated_at

    def initialize(attributes={})
      self.id = attributes[:id].to_s
      self.name = attributes[:name].to_s
      self.description = attributes[:description].to_s
      self.unit_price = attributes[:unit_price].to_s
      self.merchant_id = attributes[:merchant_id].to_s
      self.created_at = attributes[:created_at].to_s
      self.updated_at = attributes[:updated_at].to_s
    end

    def self.items
      items = []
      ObjectSpace.each_object(SalesEngine::Item) {|o| items<<o}
      items
    end

    def invoice_items_array
      invoice_items = []
      ObjectSpace.each_object(SalesEngine::InvoiceItem) {|o| invoice_items<<o}
      invoice_items
    end

    def merchants_array
      merchants = []
      ObjectSpace.each_object(SalesEngine::Merchant) {|o| merchants<<o}
      merchants
    end

    def self.random
        self.items.sample
        self.items.sample
    end

    def self.find_by_id(match)
      SalesEngine::Search.find_all_by("id", match, self.items).sample
    end

    def self.find_all_by_id(match)
      SalesEngine::Search.find_all_by("id", match, self.items)
    end

    def self.find_by_name(match)
      SalesEngine::Search.find_all_by("name", match, self.items).sample
    end

    def self.find_all_by_name(match)
      SalesEngine::Search.find_all_by("name", match, self.items)
    end

    def self.find_by_description(match)
      SalesEngine::Search.find_all_by("description", match, self.items).sample
    end

    def self.find_all_by_description(match)
      SalesEngine::Search.find_all_by("description", match, self.items)
    end

    def self.find_by_unit_price(match)
      SalesEngine::Search.find_all_by("unit_price", match, self.items).sample
    end

    def self.find_all_by_unit_price(match)
      SalesEngine::Search.find_all_by("unit_price", match, self.items)
    end

    def self.find_by_merchant_id(match)
      SalesEngine::Search.find_all_by("merchant_id", match, self.items).sample
    end

    def self.find_all_by_merchant_id(match)
      SalesEngine::Search.find_all_by("merchant_id", match, self.items)
    end

    def self.find_by_updated_at(match)
      SalesEngine::Search.find_all_by("updated_at", match, self.items).sample
    end

    def self.find_all_by_updated_at(match)
      SalesEngine::Search.find_all_by("updated_at", match, self.items)
    end

    def self.find_by_created_at(match)
      SalesEngine::Search.find_all_by("created_at", match, self.items).sample
    end

    def self.find_all_by_created_at(match)
      SalesEngine::Search.find_all_by("created_at", match, self.items)
    end

    def invoice_items
      invoice_items = []
      invoice_items = invoice_items_array.select { |inv| inv.item_id == id}
    end

    def merchant
      merchant = merchants_array.select { |merch| merch.id == merchant_id}
      merchant[0]
    end

  end
end