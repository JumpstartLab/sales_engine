#require './invoice'
require './lib/sales_engine/find'

module SalesEngine
  class InvoiceItem
    extend Find

    attr_accessor :id, :item_id, :invoice_id, :quantity, 
                  :unit_price, :created_at, :updated_at, 
                  :inv_success, :total

    def initialize(attributes={})
      self.id         = attributes[:id]
      self.item_id    = attributes[:item_id]
      self.invoice_id = attributes[:invoice_id]
      self.quantity   = attributes[:quantity]
      self.unit_price = attributes[:unit_price]
      self.created_at = attributes[:created_at]
      self.updated_at = attributes[:updated_at]
    end

    class << self
      attributes = [:id, :item_id, :invoice_id, :quantity, 
                  :unit_price, :created_at, :updated_at, :date]
      attributes.each do |attribute|
        define_method "find_by_#{attribute}" do |input|
          find_invoice_items(attribute, input.to_s)
        end
        define_method "find_all_by_#{attribute}" do |input|
          find_all_invoice_items(attribute, input.to_s)
        end
      end
    end

    def total
      @total ||= (self.quantity.to_f * self.unit_price.to_f)/100
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
      # returns an instance of Invoice associated with this object
      Database.instance.invoices.find do |i|
        i.send(:id) == self.invoice_id
      end
    end

    def item
      #item returns an instance of Item associated with this object
      Database.instance.items.find do |i|
        i.send(:id) == self.item_id
      end
    end

  end
end