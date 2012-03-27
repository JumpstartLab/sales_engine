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
      SalesEngine::Database.instance.invoiceitems
    end

    def invoice
      matched_invoices = SalesEngine::Invoice.find_all_by_id(self.invoice_id)
      matched_invoices[0]
      # invoiceitems = SalesEngine::Database.instance.invoiceitems
      # matched_invoiceitems = invoiceitems.select { |invoiceitem| invoiceitem.id == self.id }
      # invoiceitem_ids = matched_invoiceitems.map { |invoiceitem| invoiceitem.invoice_id }
      # invoiceitem_ids.map { |invoiceitem_id| SalesEngine::Invoice.find_by_id(invoiceitem_id) }
    end

    def item
      matched_items = SalesEngine::Item.find_all_by_id(self.item_id)
      matched_items[0]
      # invoiceitems = SalesEngine::Database.instance.invoiceitems
      # matched_invoiceitems = invoiceitems.select { |invoiceitem| invoiceitem.id == self.id }
      # invoiceitem_ids = matched_invoiceitems.map { |invoiceitem| invoiceitem.item_id }
      # invoiceitem_ids.map { |invoiceitem_id| SalesEngine::Item.find_by_id(invoiceitem_id) }
    end

  end
end