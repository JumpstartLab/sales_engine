module SalesEngine
  class InvoiceItem
    extend Searchable
    attr_accessor :id, :item_id, :invoice_id, :quantity, :unit_price
    attr_accessor :line_total, :date
    # attr_accessor :raw_csv

    def self.records
      @invoice_items ||= get_invoice_items
    end

    def self.get_invoice_items
      CSVManager.load('data/invoice_items.csv').map do |record|
        InvoiceItem.new(record)
      end
    end

    # def self.csv_headers
    #   @csv_headers
    # end

    # def self.csv_headers=(value)
    #   @csv_headers=(value)
    # end

    def self.create(params)
      records << self.new(params)
    end

    def self.populate_stats
      records.each do |record|
        record.populate_stats if record.invoice.successful_transaction
      end
    end

    def populate_stats
      merchant.total_revenue += line_total
      merchant.items_sold += quantity
      item.total_revenue += line_total
      item.items_sold += quantity
      customer.revenue_bought += line_total
      customer.items_bought += quantity
      invoice.total_paid += line_total
      invoice.num_items += quantity
    end

    def initialize(raw_line)
      self.id = raw_line[:id].to_i
      self.item_id = raw_line[:item_id].to_i
      self.invoice_id = raw_line[:invoice_id].to_i
      self.quantity = raw_line[:quantity].to_i
      self.unit_price = clean_unit_price(raw_line[:unit_price])
      self.line_total = quantity * unit_price
      # self.raw_csv = raw_line.values
      # InvoiceItem.csv_headers ||= raw_line.keys
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
      @date ||= invoice.created_at
    end

    private

    def clean_unit_price(raw_data)
      BigDecimal(raw_data) / 100
    end
  end
end