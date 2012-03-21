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
      Database.instance.merchant_list.detect{ |merchant| merchant.send(att.to_sym) == param }
    end
  end

  MERCHANT_ATTS.each do |att|
    define_singleton_method ("find_all_by_" + att).to_sym do |param|
      Database.instance.merchant_list.select{ |merchant| merchant if merchant.send(att.to_sym) == param }
    end
  end
end