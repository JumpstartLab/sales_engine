module SalesEngine
  class Item
    extend Searchable
    attr_accessor :name, :id, :description, :unit_price
    attr_accessor :merchant_id, :total_revenue, :items_sold
    # attr_accessor :raw_csv

    def self.records
      @items ||= HashyHash.new(get_items) do |h|
        h.unique :id
        h.foreign :merchant_id
      end
    end

    def self.get_items
      CSVManager.load('data/items.csv').collect do |record|
        Item.new(record)
      end
    end

    # def self.csv_headers
    #   @csv_headers
    # end

    # def self.csv_headers=(value)
    #   @csv_headers=(value)
    # end

    def self.most_revenue(num_items)
      all.sort_by{|i| - i.total_revenue}.first(num_items)
    end

    def self.most_items(num_items)
      all.sort_by{|i| - i.items_sold}.first(num_items)
    end

    def initialize(raw_line)
      self.name = raw_line[:name]
      self.id = raw_line[:id].to_i
      self.description = raw_line[:description]
      self.merchant_id = raw_line[:merchant_id].to_i
      self.unit_price = clean_unit_price(raw_line[:unit_price])
      self.total_revenue = 0
      self.items_sold = 0
      # self.raw_csv = raw_line.values
      # Item.csv_headers ||= raw_line.keys
    end

    def invoice_items
      @invoice_items ||= SalesEngine::InvoiceItem.find_all_by_item_id(self.id)
    end

    def merchant
      @merchant ||= SalesEngine::Merchant.find_by_id(self.merchant_id)
    end

    def best_day
      results = Hash.new(0)
      invoice_items.each do |item|
        results[item.date] += item.quantity
      end
      results.sort_by { |k, v| v }.last.first
    end

    private

    def clean_unit_price(raw_data)
      BigDecimal(raw_data) / 100
    end

  end
end