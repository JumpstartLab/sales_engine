require 'sales_engine/model'


class SalesEngine
  class InvoiceItem
    ATTRIBUTES = ["id", "created_at", "updated_at", "item_id", "invoice_id",
               "quantity", "unit_price"]

    def self.finder_attributes
      ATTRIBUTES
    end

    include Model

    attr_accessor :id, :item_id, :invoice_id, :quantity, :unit_price, :total,
    :created_at, :updated_at, :unit_price

    def initialize(attributes)
        super
        @item_id = attributes[:item_id].to_i
        @invoice_id = attributes[:invoice_id].to_i
        @quantity = attributes[:quantity].to_i
        @unit_price = BigDecimal.new(attributes[:unit_price]) / 100
    end

    def invoice
      SalesEngine::Invoice.find_by_id(@invoice_id)
    end

    def item
      SalesEngine::Item.find_by_id(@item_id)
    end

    def total
      @quantity.to_i * @unit_price.to_i
    end


    # making a new invoice item from a passed in item and invoice_id
    def self.create(attr)
      if (self.find_by_invoice_id(attr[:invoice_id]))
        self.find_by_invoice_id(attr[:invoice_id]).quantity += 1
      else
        ii = self.new( {:invoice_id => attr[:invoice_id],
                      :unit_price => unit_price,
                      :item_id => attr[:item].id,
                      :quantity => 1 })
      end
    end

    #     def self.add_to_db(input)
    #   if self.find_by_id(input.id) == nil
    #     SalesEngine::Database.instance.invoices << input
    #   end
    # end

    # def self.create(attr)
    #   invoice = self.new ( { :customer_id => attr[:customer].id,
    #     :merchant_id => attr[:merchant].id, :status => attr[:status] } )
    #   # add invoice items
    #   last_id = SalesEngine::Database.instance.invoices.last.id
    #   invoice.id =last_id + 1
    #   self.add_to_db(invoice)
    #   invoice
    # end

    # id,item_id,invoice_id,quantity,unit_price,created_at,updated_at
  end
end


