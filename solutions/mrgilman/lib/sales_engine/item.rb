module SalesEngine
  class Item
    #extend SalesEngine::Search
    attr_accessor :id,
                  :name,
                  :description,
                  :unit_price,
                  :merchant_id,
                  :created_at,
                  :updated_at,
                  :total_sold,
                  :total_revenue

    def initialize(attributes={})
      self.id            = attributes[:id].to_i
      self.name          = attributes[:name].to_s
      self.description   = attributes[:description].to_s
      self.unit_price    = BigDecimal.new(attributes[:unit_price].to_s)/100
      self.merchant_id   = attributes[:merchant_id].to_i
      self.created_at    = Date.parse(attributes[:created_at])
      self.updated_at    = Date.parse(attributes[:updated_at])
      self.total_sold    = 0
      self.total_revenue = 0
    end

    def self.items
      items = DataStore.instance.items
    end

    def invoice_items_array
      invoice_items = DataStore.instance.invoice_items
    end

    def merchants_array
      merchants = DataStore.instance.merchants
    end

    def self.random
        self.items.sample
    end

    def self.method_missing(method_name, *args, &block)
      if method_name =~ /^find_by_(\w+)$/
        Search.find_by_attribute($1, args.first, self.items)
      elsif method_name =~ /^find_all_by_(\w+)$/
        Search.find_all_by_attribute($1, args.first, self.items)
      else
        super
      end
    end

    def invoice_items
      @invoice_items ||= invoice_items_array.select { |inv| inv.item_id == id}
    end

    def successful_invoice_items
      invoice_items.select {|inv_item| inv_item.invoice.successful?}
    end

    def merchant
      merchant = merchants_array.select { |merch| merch.id == merchant_id}
      merchant[0]
    end

    def item_revenue
      revenue = 0
      successful_invoice_items.each do |inv_item|
        revenue = revenue + inv_item.total
      end
      BigDecimal.new(revenue.to_s)
    end


    def item_quantity
      qty = 0
      successful_invoice_items.each do |inv_item|
        qty = qty + inv_item.quantity
      end
      qty
    end

    def self.set_revenue
      self.items.each do |item|
        item.total_revenue = item.item_revenue
      end
    end

    def self.most_revenue(x)
      self.set_revenue
      sorted_items = self.items.sort_by { |item| item.total_revenue }.reverse
      sorted_items[0..x-1]
    end

    def self.set_quantity
      self.items.each do |item|
        item.total_sold = item.item_quantity
      end
    end

    def self.most_items(x)
      self.set_quantity
      sorted_items = self.items.sort_by { |item| item.total_sold }.reverse
      sorted_items[0..x-1]
    end

    def days_hash
      days_hash = {}
      successful_invoice_items.each do|inv_item|
        if days_hash.has_key?(inv_item.invoice.created_at)
          days_hash[inv_item.invoice.created_at] += inv_item.quantity
        else
          days_hash[inv_item.invoice.created_at] = inv_item.quantity
        end
      end
      days_hash
    end

    def best_day
      days_hash.max_by{ |date, count| count}[0]
    end
  end
end




