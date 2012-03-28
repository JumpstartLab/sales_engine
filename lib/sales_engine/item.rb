module SalesEngine
  class Item < Record
    attr_accessor :name, :description, :unit_price, :merchant_id

    def initialize(attributes={})
      super
      self.name = attributes[:name]
      self.description = attributes[:description]
      self.unit_price = convert_to_big_decimal(attributes[:unit_price])
      self.merchant_id = attributes[:merchant_id].to_i
    end

    def self.most_revenue(item_count)
      SalesEngine::Database.instance.items.sort_by { |item| 
        item.total }.pop_multiple(item_count)
    end

    def self.most_items(item_count)
      SalesEngine::Database.instance.items.sort_by { |item| 
        item.paid_invoice_items.count }.pop_multiple(item_count)
    end

    def self.random
      SalesEngine::Database.instance.get_random_record("items")
    end

    def best_day
      day_tracker = { }
      self.paid_invoice_items.each do |invoice_item|
        temp_date = Date.parse(Time.parse(invoice_item.created_at).strftime('%Y/%m/%d'))
        if day_tracker[temp_date]
          day_tracker[temp_date] += 1
        else
          day_tracker[temp_date] = 1
        end
      end
      day_tracker.sort_by {|day| day.last}.last.first
    end

    def paid_invoice_items
      invoice_items.select { |invoice_item| 
        invoice_item.sold? }
    end

    def total
      invoice_items.collect { |invoice_item| invoice_item.total }.sum
    end

    def invoice_items
      SalesEngine::Database.instance.find_all_by("invoiceitems", "item_id", self.id)
    end

    def merchant
      SalesEngine::Database.instance.find_by("merchants", "id", self.merchant_id)
    end

    def self.find_by_id(id)
      SalesEngine::Database.instance.find_by("items", "id", id)
    end

    def self.find_by_name(name)
      SalesEngine::Database.instance.find_by("items", "name", name)
    end

    def self.find_by_description(description)
      SalesEngine::Database.instance.find_by("items", "description", description)
    end

    def self.find_by_unit_price(unit_price)
      SalesEngine::Database.instance.find_by("items", "unit_price", unit_price)
    end

    def self.find_by_merchant_id(merchant_id)
      SalesEngine::Database.instance.find_by("items", "merchant_id", merchant_id)
    end

    def self.find_by_created_at(time)
      SalesEngine::Database.instance.find_by("items", "created_at", time)
    end

    def self.find_by_updated_at(time)
      SalesEngine::Database.instance.find_by("items", "updated_at", time)
    end

    def self.find_all_by_id(id)
      SalesEngine::Database.instance.find_all_by("items", "id", id)
    end

    def self.find_all_by_name(name)
      SalesEngine::Database.instance.find_all_by("items", "name", name)
    end

    def self.find_all_by_description(description)
      SalesEngine::Database.instance.find_all_by("items", "description", description)
    end

    def self.find_all_by_unit_price(unit_price)
      SalesEngine::Database.instance.find_all_by("items", "unit_price", unit_price)
    end

    def self.find_all_by_merchant_id(merchant_id)
      SalesEngine::Database.instance.find_all_by("items", "merchant_id", merchant_id)
    end

    def self.find_all_by_created_at(time)
      SalesEngine::Database.instance.find_all_by("items", "created_at", time)
    end

    def self.find_all_by_updated_at(time)
      SalesEngine::Database.instance.find_all_by("items", "updated_at", time)
    end
  end
end