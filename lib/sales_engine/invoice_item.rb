module SalesEngine
  class InvoiceItem
    attr_accessor :id,
                  :item_id,
                  :invoice_id,
                  :quantity,
                  :unit_price,
                  :created_at,
                  :updated_at,
                  :total

    def initialize(attributes={})
      self.id = attributes[:id].to_i
      self.item_id = attributes[:item_id].to_i
      self.invoice_id = attributes[:invoice_id].to_i
      self.quantity = attributes[:quantity].to_i
      self.unit_price = attributes[:unit_price].to_i
      self.created_at = attributes[:created_at].to_s
      self.updated_at = attributes[:updated_at].to_s
      self.total = attributes[:quantity].to_i * attributes[:unit_price].to_i
    end

    def self.random
      self.invoice_items.sample
    end

    def items_array
      items = DataStore.instance.items
    end

    def invoices_array
      invoices = DataStore.instance.invoices
    end

    def item
      item=[]
      item = items_array.select { |item| item.id ==  item_id }
    end

    def invoice
      invoices_array.detect { |inv| inv.id == invoice_id}
    end

    def self.invoice_items
      invoice_items = DataStore.instance.invoice_items
    end

  end
end

