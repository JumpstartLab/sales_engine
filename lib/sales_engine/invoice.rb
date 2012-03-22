module SalesEngine
	class Invoice
		extend Searchable
		attr_accessor :customer_id, :id, :merchant_id, :status

		def self.records
			Engine.instance.invoices
		end

		def self.get_invoices
			CSVLoader.load('data/invoices.csv').collect do |record|
				Invoice.new(record)
			end
		end

		def initialize(raw_line)
			self.id = raw_line[:id]
			self.customer_id = raw_line[:customer_id]
			self.merchant_id = raw_line[:merchant_id]
			self.status = raw_line[:status]
		end

		def transactions
			SalesEngine::Transaction.find_all_by_invoice_id(self.id)
		end

		def invoice_items
			SalesEngine::InvoiceItem.find_all_by_invoice_id(self.id)
		end

		def items
			result = invoice_items.collect do |invoice_item|
				invoice_item.item
			end
			result.uniq
		end

		def customer
			SalesEngine::Customer.find_by_id(self.customer_id)
		end

	end
end