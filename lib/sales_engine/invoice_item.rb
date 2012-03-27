module SalesEngine
  class InvoiceItem
    extend Searchable
    attr_accessor :id, :item_id, :invoice_id, :quantity, :unit_price
    attr_accessor :line_total, :date, :raw_csv

    def self.records
      @invoice_items ||= get_invoice_items
    end

    def self.get_invoice_items
      CSVManager.load('data/invoice_items.csv').collect do |record|
        InvoiceItem.new(record)
      end
    end

    def self.csv_headers
      @csv_headers
    end

    def self.csv_headers=(value)
      @csv_headers=(value)
    end

    def self.populate_stats
      records.each do |record|
        record.merchant.total_revenue += record.line_total
        record.merchant.items_sold += record.quantity
        record.item.total_revenue += record.line_total
        record.item.items_sold += record.quantity
        record.customer.revenue_bought += record.line_total
        record.customer.items_bought += record.quantity
        record.invoice.total_paid += record.line_total
        record.invoice.num_items += record.quantity
      end
    end

    def self.create(params)
      records << self.new(params)
    end

    def initialize(raw_line)
      self.id = raw_line[:id].to_i
      self.item_id = raw_line[:item_id].to_i
      self.invoice_id = raw_line[:invoice_id].to_i
      self.quantity = raw_line[:quantity].to_i
      self.unit_price = clean_unit_price(raw_line[:unit_price])
      self.line_total = quantity * unit_price
      self.raw_csv = raw_line.values
      InvoiceItem.csv_headers ||= raw_line.keys
    end

    def merchant
      @merchant ||= SalesEngine::Merchant.find_by_id(invoice.merchant_id)
    end

    def customer
      @customer ||= SalesEngine::Customer.find_by_id(invoice.customer_id)
    end

    def invoice
      @invoice ||= SalesEngine::Invoice.find_by_id(self.invoice_id)
    end

    def item
      @item ||= SalesEngine::Item.find_by_id(self.item_id)
    end

    def date
      @date ||= SalesEngine::Invoice.find_by_id(invoice_id).created_at
    end

    private

    def clean_unit_price(raw_data)
      BigDecimal(raw_data) / 100
    end
  end
end