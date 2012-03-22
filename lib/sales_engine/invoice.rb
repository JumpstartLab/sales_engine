module SalesEngine
	class Invoice
		extend Searchable
		attr_accessor :customer_id, :id, :merchant_id, :status

		def self.records
			@invoices ||= get_invoices
		end

		def self.get_invoices
			CSVLoader.load('data/invoices.csv').collect do |record|
				Invoice.new(record)
			end
		end

		def initialize(raw_line)
			self.id = raw_line[:id].to_i
			self.customer_id = raw_line[:customer_id].to_i
			self.merchant_id = raw_line[:merchant_id].to_i
			self.status = raw_line[:status]
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
		# 	else
		# 		0
		# 	end
		end

		private

		# def successful_transaction
		# 	@successful_transaction ||= transactions.map(&:result).include?("success")
		# end
	end
end