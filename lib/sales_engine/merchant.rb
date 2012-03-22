module SalesEngine
  class Merchant
    attr_accessor :id,
                  :name,
                  :created_at,
                  :updated_at

    def initialize(attributes={})
      self.id = attributes[:id]
      self.name = attributes[:name]
      self.created_at = attributes[:created_at]
      self.updated_at = attributes[:updated_at]
    end

    def self.merchants
      merchants = []
      ObjectSpace.each_object(SalesEngine::Merchant) {|o| merchants<<o}
      merchants
    end

    def items_array
      items = []
      ObjectSpace.each_object(SalesEngine::Item) {|o| items<<o}
      items
    end

    def invoices_array
      invoices = []
      ObjectSpace.each_object(SalesEngine::Invoice) {|o| invoices<<o}
      invoices
    end

    def self.random
        self.merchants.sample
        self.merchants.sample
    end

    def self.find_by_id(match)
      SalesEngine::Search.find_all_by("id", match, self.merchants).sample
    end

    def self.find_all_by_id(match)
      SalesEngine::Search.find_all_by("id", match, self.merchants)
    end

    def self.find_by_name(match)
      SalesEngine::Search.find_all_by("name", match, self.merchants).sample
    end

    def self.find_all_by_name(match)
      SalesEngine::Search.find_all_by("name", match, self.merchants)
    end

    def self.find_by_updated_at(match)
      SalesEngine::Search.find_all_by("updated_at", match, self.merchants).sample
    end

    def self.find_all_by_updated_at(match)
      SalesEngine::Search.find_all_by("updated_at", match, self.merchants)
    end

    def self.find_by_created_at(match)
      SalesEngine::Search.find_all_by("created_at", match, self.merchants).sample
    end

    def self.find_all_by_created_at(match)
      SalesEngine::Search.find_all_by("created_at", match, self.merchants)
    end

    def items
      items = []
      items = items_array.select { |item| item.merchant_id ==  id }
    end

    def invoices
      invoices = []
      invoices = invoices_array.select { |inv| inv.merchant_id == id}
    end
  end
end