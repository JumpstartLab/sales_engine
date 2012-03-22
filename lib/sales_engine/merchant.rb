module SalesEngine
  class Merchant
    attr_accessor :id, :name, :created_at, :updated_at

    MERCHANT_ATTS = [
      "id",
      "name",
      "created_at",
      "updated_at"
    ]

    def initialize(attributes)
      self.id = attributes[:id]
      self.name = attributes[:name]
      self.created_at = attributes[:created_at]
      self.updated_at = attributes[:updated_at]
    end

    MERCHANT_ATTS.each do |att|
      define_singleton_method ("find_by_" + att).to_sym do |param|
        SalesEngine::Database.instance.merchant_list.detect do |merchant|
          merchant.send(att.to_sym).to_s.downcase == param.to_s.downcase
        end
      end
    end

    MERCHANT_ATTS.each do |att|
      define_singleton_method ("find_all_by_" + att).to_sym do |param|
        SalesEngine::Database.instance.merchant_list.select do |merchant|
          merchant if merchant.send(att.to_sym).to_s.downcase == param.to_s.downcase
        end
      end
    end
  end
end