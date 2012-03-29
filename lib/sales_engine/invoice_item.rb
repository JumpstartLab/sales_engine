module SalesEngine
  require 'sales_engine/dynamic_finder'
  class InvoiceItem
    attr_accessor :id, :item_id, :invoice_id, :quantity,
                  :unit_price, :created_at, :updated_at, :date

    INVOICE_ITEM_ATTS = [
      "id",
      "item_id",
      "invoice_id",
      "quantity",
      "unit_price",
      "created_at",
      "updated_at"
    ]
    def initialize(attributes)
      if attributes[:id]
        self.id = attributes[:id].to_i
      else
        self.id = SalesEngine::Database.instance.invoice_item_list.size + 1
        # puts self.id
        # puts SalesEngine::Database.instance.invoice_item_list.inspect
      end
      self.item_id = attributes[:item_id].to_i
      self.invoice_id = attributes[:invoice_id].to_i
      self.quantity =   attributes[:quantity].to_i
      if attributes[:unit_price].class == BigDecimal
        self.unit_price = attributes[:unit_price]
      else
        self.unit_price = BigDecimal.new(attributes[:unit_price])/100
      end

      SalesEngine::Database.instance.invoice_item_list << self
      SalesEngine::Database.instance.invoice_item_id_hash[ self.id ] = self
    end

    def self.attributes_for_finders
      INVOICE_ITEM_ATTS
    end

    def format_created_at
      self.invoice.created_at.strftime("%Y/%m/%d")
    end

    extend SalesEngine::DynamicFinder

    def self.total_revenue
      #this includes only invoice items w/ successful transactions
      total_revenue = BigDecimal.new("0.00")
      data = successful_invoice_items
      data.each do |invoice_item|
        total_revenue += invoice_item.revenue
      end
      total_revenue
    end

    def self.create(attributes)
      invoice_item = self.new({ :item_id => attributes[:item].id,
                              :invoice_id => attributes[:invoice_id],
                              :unit_price => attributes[:item].unit_price,
                              :quantity => "1" })
      SalesEngine::Database.instance.invoice_item_list << invoice_item
      invoice_item
    end

    def self.total_revenue_by_invoice_id(invoice_id)
      total_revenue = BigDecimal.new("0.00")
      find_all_by_invoice_id(invoice_id).each do |i_i|
        total_revenue += i_i.revenue
      end
      total_revenue
    end

    def revenue
      self.quantity * self.unit_price
    end

    def invoice
      SalesEngine::Invoice.find_by_id(self.invoice_id)
    end

    def item
      SalesEngine::Item.find_by_id(self.item_id)
    end

    def merchant_id
      SalesEngine::Item.find_by_id(self.item_id).merchant_id
    end

    def is_successful?
      self.invoice.is_successful?
    end

    def self.successful_invoice_items
      invoice_item_list = SalesEngine::Database.instance.invoice_item_list

      successful_list = invoice_item_list.select do |invoice_item|
        invoice_item.is_successful?
      end
      successful_list
    end

    # def self.total_revenue_by_invoice_ids(invoice_ids)
    #   total_revenue = BigDecimal.new("0")
    #   data = invoice_ids.collect do |invoice_id|
    #     find_all_by_invoice_id(invoice_id)
    #   end
    #   data.each do |i_i|
    #     total_revenue += i_i.quantity * i_i.unit_price
    #   end
    #   total_revenue
    # end

    # def self.total_revenue_by_date(date)
    #   total_revenue = BigDecimal.new("0")
    #   data = .collect { |invoice| find_all_by_date(date) }
    #   data.each do |i_i|
    #     total_revenue += i_i.quantity * i_i.unit_price
    #   end
    #   total_revenue
    # end

    def self.find_all_by_invoice_id(invoice_id)
      SalesEngine::Database.instance.invoice_item_list.select do |i_i|
        i_i if i_i.invoice_id == invoice_id
      end
    end

    def self.find_all_by_item_id(item_id)
      SalesEngine::Database.instance.invoice_item_list.select do |i_i|
        i_i if i_i.item_id == item_id
      end
    end

    def self.find_all_by_date(date)
      date = Time.parse(date) if date.kind_of? String
      SalesEngine::Database.instance.invoice_item_list.select do |i_i|
        dt = i_i.updated_at
        i_i if date == Time.new(dt.year, dt.mon, dt.mday)
      end
    end
  end
end