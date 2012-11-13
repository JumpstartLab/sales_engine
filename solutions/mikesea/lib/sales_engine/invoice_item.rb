require 'sales_engine/find'

module SalesEngine
  class InvoiceItem
    extend Find

    attr_accessor :id, :item_id, :invoice_id, :quantity,
                  :unit_price, :created_at, :updated_at,
                  :inv_success, :total

    def initialize(attributes={})
      self.id         = attributes[:id].to_i
      self.item_id    = attributes[:item_id].to_i
      self.invoice_id = attributes[:invoice_id].to_i
      self.quantity   = attributes[:quantity].to_i
      self.unit_price = BigDecimal.new(attributes[:unit_price])/100
      self.created_at = attributes[:created_at]
      self.updated_at = attributes[:updated_at]
      self.total
    end

    class << self
      attributes = [:id, :item_id, :invoice_id, :quantity,
                  :unit_price, :created_at, :updated_at, :date]
      attributes.each do |attribute|
        define_method "find_by_#{attribute}" do |input|
          find("invoice_items", attribute, input)
        end
        define_method "find_all_by_#{attribute}" do |input|
          find_all("invoice_items", attribute, input)
        end
      end
    end

    def self.create(invoice_id, items)
      items_hash = {}
      items.each do |item|
        items_hash[item.id] = [items.count(item), item.unit_price]
      end

      items_hash.each do |item_id, values|
        ii = InvoiceItem.new(:id => Database.instance.invoice_items.count + 2,
                             :item_id     => item_id,
                             :invoice_id  => invoice_id,
                             :quantity    => values[0],
                             :unit_price  => values[1].to_s,
                             :created_at  => DateTime.now.to_s,
                             :updated_at  => DateTime.now.to_s )
        SalesEngine::Database.instance.invoice_items << ii
        ii
      end
    end

    def total
      @total ||= (self.quantity * self.unit_price)
    end

    def inv_success
      @inv_success ||= begin
        i = SalesEngine::Invoice.find_by_id(self.invoice_id)
        if i.success
          @inv_success = true
        end
      end
    end

    def date
      self.created_at.split[0]
    end

    def self.random
      Database.instance.invoice_items.sample
    end

    def invoice
      Database.instance.invoices.find do |i|
        i.send(:id) == self.invoice_id
      end
    end

    def item
      Database.instance.items.find do |i|
        i.send(:id) == self.item_id
      end
    end

  end
end