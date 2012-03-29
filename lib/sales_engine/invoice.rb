module SalesEngine
  class Invoice
    extend Searchable
    attr_accessor :customer_id, :id, :merchant_id, :status, :created_at
    # attr_accessor :raw_csv


    def self.records
      @invoices ||= get_invoices
    end

    def self.get_invoices
      CSVManager.load('data/invoices.csv').collect do |record|
        Invoice.new(record)
      end
    end

    # def self.csv_headers
    #   @csv_headers
    # end

    # def self.csv_headers=(value)
    #   @csv_headers=(value)
    # end

    def self.create(invoice_attributes)
      new_invoice = self.new( { created_at: DateTime.now.to_s } )
      set_new_invoice_attributes(new_invoice, invoice_attributes)
      invoice_attributes[:items].each do |item|
        SalesEngine::InvoiceItem.create( { item_id: item.id,
          invoice_id: new_invoice.id, created_at: DateTime.now.to_s,
          quantity: 1, unit_price: (item.unit_price*100).to_s } )
      end
      records << new_invoice
      new_invoice
    end

    def self.set_new_invoice_attributes(new_invoice, invoice_attributes)
      new_invoice.id = records.last.id + 1
      new_invoice.customer_id = invoice_attributes[:customer].id
      new_invoice.merchant_id = invoice_attributes[:merchant].id
      new_invoice.status = invoice_attributes[:status]
    end

    def self.pending
      ids = Transaction.all.select{|t| t.result != "success"}.map(&:invoice_id)
      ids.uniq.map { |id| Invoice.find_by_id(id) }
    end

    def self.average_revenue(date = nil)
      if date
        di = all.select do |i|
          i.created_at.strftime("%y%m%d") == date.strftime("%y%m%d")
        end
        tr = di.map(&:total_paid).inject(:+)
        BigDecimal((tr / di.size.to_f).round(2).to_s) rescue BigDecimal("0")
      else
        BigDecimal((all.map(&:total_paid).inject(:+) / all.size).round(2).to_s)
      end
    end

    def self.average_items(date = nil)
      if date
        di = all.select do |i|
          i.created_at.strftime("%y%m%d") == date.strftime("%y%m%d")
        end
        ti = di.map(&:num_items).inject(:+)
        BigDecimal((ti / di.size.to_f).round(2).to_s) rescue BigDecimal("0")
      else
        BigDecimal((all.map(&:num_items).inject(:+) / all.size).round(2).to_s)
      end
    end

    def initialize(raw_line)
      self.id = raw_line[:id].to_i
      self.customer_id = raw_line[:customer_id].to_i
      self.merchant_id = raw_line[:merchant_id].to_i
      self.status = raw_line[:status]
      self.created_at = DateTime.parse(raw_line[:created_at])
      # self.raw_csv = raw_line.values
      # Invoice.csv_headers ||= raw_line.keys
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
      @items ||= invoice_items.map(&:item).uniq
    end

    def customer
      @customer ||= SalesEngine::Customer.find_by_id(self.customer_id)
    end

    def total_paid
      successful_transaction ? @total_paid : 0
    end

    def total_paid=(value)
      @total_paid = value
    end

    def num_items
      successful_transaction ? @num_items : 0
    end

    def num_items=(value)
      @num_items = value
    end

    def charge(params)
      t = { invoice_id: id }
      SalesEngine::Transaction.create(t.merge(params))
      @transactions = SalesEngine::Transaction.find_all_by_invoice_id(id)
      if params[:result] == "success"
        invoice_items.each { |item| item.populate_stats }
      end
    end

    def successful_transaction
      transactions.map(&:result).include?("success")
    end
  end
end