module SalesEngine
	class Invoice
		extend Searchable
		attr_accessor :customer_id, :id, :merchant_id, :status

		def self.records
			Engine.instance.invoices
		end

		def self.get_invoices
			CSVLoader.load('data_files/invoices.csv').collect do |record|
				Invoice.new(record)
			end
		end

		def initialize(raw_line)
			self.id = raw_line[:id]
			self.customer_id = raw_line[:customer_id]
			self.merchant_id = raw_line[:merchant_id]
			self.status = raw_line[:status]
		end

	end
end