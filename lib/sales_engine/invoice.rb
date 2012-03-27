module SalesEngine
  class Invoice
    extend Searchable
    attr_accessor :customer_id, :id, :merchant_id, :status, :created_at
    attr_accessor :raw_csv


    def self.records
      @invoices ||= get_invoices
    end

    def self.get_invoices
      CSVManager.load('data/invoices.csv').collect do |record|
        Invoice.new(record)
      end
    end

    def self.csv_headers
      @csv_headers
    end

    def self.csv_headers=(value)
      @csv_headers=(value)
    end

    def self.create(invoice_attributes)
      new_invoice = self.new( { created_at: DateTime.now.to_s } )
      new_invoice.id = records.last.id + 1
      new_invoice.customer_id = invoice_attributes[:customer_id].id
      new_invoice.merchant_id = invoice_attributes[:merchant_id].id
      new_invoice.status = invoice_attributes[:status]
      invoice_attributes[:items].each do |item|
        SalesEngine::InvoiceItem.create( { item_id: item.id,
          invoice_id: new_invoice.id, created_at: DateTime.now.to_s,
          uantity: 1, unit_price: item.unit_price.to_s } )
      end
      SalesEngine::Transaction.create({invoice_id: new_invoice.id})
      records << new_invoice
      new_invoice
    end

    def self.pending
      ids = Transaction.all.select{|t| t.result != "success"}.map(&:invoice_id)
      ids.uniq.collect { |id| Invoice.find_by_id(id) }
    end

    def self.average_revenue(date = nil)
      if date
        di = all.select do |i|
          i.created_at.strftime("%y%m%d") == date.strftime("%y%m%d")
        end
        total_rev = di.map(&:total_paid).inject(:+)
        BigDecimal((total_rev / di.size.to_f).to_s) rescue BigDecimal("0")
      else
        BigDecimal((all.map(&:total_paid).inject(:+) / all.size).to_s)
      end
    end

    def self.average_items(date = nil)
      if date
        di = all.select do |i|
          i.created_at.strftime("%y%m%d") == date.strftime("%y%m%d")
        end
        total_items = di.map(&:num_items).inject(:+)
        BigDecimal((total_items / di.size.to_f).to_s) rescue BigDecimal("0")
      else
        BigDecimal((all.map(&:num_items).inject(:+) / all.size).to_s)
      end
    end

    def initialize(raw_line)
      self.id = raw_line[:id].to_i
      self.customer_id = raw_line[:customer_id].to_i
      self.merchant_id = raw_line[:merchant_id].to_i
      self.status = raw_line[:status]
      self.created_at = DateTime.parse(raw_line[:created_at])
      self.raw_csv = raw_line.values
      Invoice.csv_headers ||= raw_line.keys
      self.total_paid = 0
      self.num_items = 0
    end

    def transactions
      @transactions ||= SalesEngine::Transaction.find_all_by_invoice_id(id)
    end

    def invoice_items
      @invoice_items ||= SalesEngine::InvoiceItem.find_all_by_invoice_id(id)
    end

    def items
      @items ||= invoice_items.collect do |invoice_item|
        invoice_item.item
      end
      @items.uniq
    end

    def customer
      @customer ||= SalesEngine::Customer.find_by_id(self.customer_id)
    end

    def total_paid
      if successful_transaction
        @total_paid
      else
        0
      end
    end

    def total_paid=(value)
      @total_paid = value
    end

    def num_items
      if successful_transaction
        @num_items
      else
        0
      end
    end

    def num_items=(value)
      @num_items = value
    end

    def charge(params)
      t = transactions.first
      t.credit_card_number = params[:credit_card_number]
      t.credit_card_expiration_date = params[:credit_card_expiration]
      t.result = params[:result]
    end

    def successful_transaction
      transactions.map(&:result).include?("success")
    end
  end
end