module SalesEngine
  class InvoiceItem
    attr_accessor :id, :item_id, :invoice_id, :quantity, :unit_price, :created_at, :updated_at

    def initialize(attributes)
      self.id         = attributes[:id]
      self.item_id    = attributes[:item_id]
      self.invoice_id = attributes[:invoice_id]
      self.quantity   = attributes[:quantity]
      self.unit_price = attributes[:unit_price]
      self.created_at = attributes[:created_at]
      self.updated_at = attributes[:updated_at]
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
      matched_invoices = SalesEngine::Invoice.find_all_by_id(self.invoice_id)
      matched_invoices[0]
    end

    def item
      matched_items = SalesEngine::Item.find_all_by_id(self.item_id)
      matched_items[0]
    end

    def revenue
      quantity.to_i * unit_price.to_i
    end
 
    def total
      @total ||= quantity.to_i * unit_price.to_i
    end

  end
end