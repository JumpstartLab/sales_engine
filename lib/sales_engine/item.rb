module SalesEngine
  class Item < Record
    attr_accessor :name, :description, :unit_price, :merchant_id

    def initialize(attributes={})
      super
      self.name = attributes[:name]
      self.description = attributes[:description]
      self.unit_price = attributes[:unit_price]
      self.merchant_id = attributes[:merchant_id]
    end

    def self.most_revenue(item_count)
      revenue_tracker = []
      return_items = []
      SalesEngine::Database.instance.items.each { |item|
        revenue = 0
        item.invoice_items.each { |invoice_item| revenue += invoice_item.unit_price }
        revenue_tracker << { :item => item, :total_revenue => revenue } }
      sorted_items = revenue_tracker.sort_by { |item| item[:total_revenue] }
      SalesEngine::Item.pop_items(item_count, sorted_items)
    end

    def self.most_items(item_count)
      item_tracker = []
      SalesEngine::Database.instance.items.each { |item|
        item_tracker << { :item => item, :item_count => item.invoice_items.count } }
      sorted_items = item_tracker.sort_by { |item| item[:item_count] }
      SalesEngine::Item.pop_items(item_count, sorted_items)
    end

    def self.pop_items(pop_count, item_list)
      return_items = []
      pop_count.times do
        element = item_list.pop
        return_items << element[:item]
      end
      return_items
    end

   def self.random
      SalesEngine::Database.instance.get_random_record("items")
    end

    def best_day
      day_tracker = { }
      self.invoice_items.each do |invoice_item|
        temp_date = Date.parse(Time.parse(invoice_item.created_at).strftime('%Y/%m/%d'))
        if day_tracker[temp_date]
          day_tracker[temp_date] += 1
        else
          day_tracker[temp_date] = 1
        end
      end
      day_tracker.sort_by {|day| day.last}.last.first

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