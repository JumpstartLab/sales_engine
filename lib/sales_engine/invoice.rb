module SalesEngine
  class Invoice
    extend Searchable
    attr_accessor :customer_id, :id, :merchant_id, :status, :created_at

    def self.records
      @invoices ||= get_invoices
    end

    def self.get_invoices
      CSVLoader.load('data/invoices.csv').collect do |record|
        Invoice.new(record)
      end
    end

    def self.create(invoice_attributes)
      new_invoice = self.new({created_at: DateTime.now.to_s})
      new_invoice.id = records.last.id + 1
      new_invoice.customer_id = invoice_attributes[:customer_id].id
      new_invoice.merchant_id = invoice_attributes[:merchant_id].id
      new_invoice.status = invoice_attributes[:status]
      invoice_attributes[:items].each do |item|
        SalesEngine::InvoiceItem.create({item_id: item.id, invoice_id: new_invoice.id, created_at: DateTime.now.to_s, quantity: 1, unit_price: item.unit_price.to_s})
      end
      SalesEngine::Transaction.create({invoice_id: new_invoice.id})
      records << new_invoice
      new_invoice
    end

    def initialize(raw_line)
      self.id = raw_line[:id].to_i
      self.customer_id = raw_line[:customer_id].to_i
      self.merchant_id = raw_line[:merchant_id].to_i
      self.status = raw_line[:status]
      self.created_at = DateTime.parse(raw_line[:created_at])
    end

    def transactions
      @transactions ||= SalesEngine::Transaction.find_all_by_invoice_id(self.id)
    end

    def invoice_items
      @invoice_items ||= SalesEngine::InvoiceItem.find_all_by_invoice_id(self.id.to_i)
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
      # if successful_transaction
        @total_paid ||= invoice_items.map(&:line_total).inject(:+)
    #   else
    #     0
    #   end
    end

    def charge(params)
      transactions.first.credit_card_number = params[:credit_card_number]
      transactions.first.credit_card_expiration_date = params[:credit_card_expiration]
      transactions.first.result = params[:result]
    end

    private

    # def successful_transaction
    #   @successful_transaction ||= transactions.map(&:result).include?("success")
    # end
  end
end