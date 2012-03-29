require 'bigdecimal'

module SalesEngine
  class InvoiceItem
    extend Randomize
    extend Searchable

    attr_accessor :id, :item_id, :invoice_id,
                  :quantity, :unit_price, :created_at, :updated_at

    def initialize(attributes)
      self.id         = attributes[:id].to_i
      self.item_id    = attributes[:item_id].to_i
      self.invoice_id = attributes[:invoice_id].to_i
      self.quantity   = attributes[:quantity].to_i
      self.unit_price = sanitize_unit_price(attributes[:unit_price])
      self.created_at = Date.parse(attributes[:created_at])
      self.updated_at = Date.parse(attributes[:updated_at])
    end

    class << self
      [:id, :item_id, :invoice_id,
       :quantity, :unit_price, :created_at,
       :updated_at].each do |attribute|
        define_method "find_by_#{attribute}" do |input|
          find_by_(attribute, input)
        end
      end

      [:id, :item_id, :invoice_id,
       :quantity, :unit_price, :created_at,
       :updated_at].each do |attribute|
        define_method "find_all_by_#{attribute}" do |input|
          find_all_by_(attribute, input)
        end
      end
    end

    def self.create(invoice_id,items)
      items_hash = {}

      items.each do |item|
        items_hash[item.id.to_sym] = [items.count(item),item.unit_price]
      end

      items_hash.each do|item_id,values|

        ii = InvoiceItem.new(:id => Database.instance.invoiceitems.count + 2,
                             :item_id => item_id,
                             :invoice_id => invoice_id,
                             :quantity => values[0],
                             :unit_price => values[1].to_s,
                             :created_at => DateTime.now.to_s,
                             :updated_at => DateTime.now.to_s )
        SalesEngine::Database.instance.invoiceitems << ii
        ii
      end
    end

    def self.collection
      database.invoiceitems
    end

    def self.database
      SalesEngine::Database.instance
    end

    def database
      @database ||= SalesEngine::Database.instance
    end

    def database=(input)
      @database = input
    end

    def invoice
      SalesEngine::Invoice.find_by_id(self.invoice_id)
    end

    def item
      SalesEngine::Item.find_by_id(self.item_id)
      # SalesEngine::Database.instance.items.find do |i|
      #   i.send(:id) == self.item_id
      # end
      # matched_items = SalesEngine::Item.find_by_id(self.item_id)
      # matched_items[0]
    end

    def total
      @total ||= quantity.to_i * unit_price
    end

    def quantity
      @quantity ||= quantity.to_i
    end

    private

    def sanitize_unit_price(original_price)
      BigDecimal(original_price.to_s)/100
    end

  end
end