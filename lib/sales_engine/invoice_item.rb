module SalesEngine
	class InvoiceItem
		attr_accessor :id, :item_id, :invoice_id, :quantity, :unit_price

		def self.records
			Engine.instance.invoice_items
		end

		def self.get_invoice_items
			CSVLoader.load('data_files/invoice_items.csv').collect do |record|
				InvoiceItem.new(record)
			end
		end

		def initialize(raw_line)
			self.id = raw_line[:id]
			self.item_id = raw_line[:item_id]
			self.invoice_id = raw_line[:invoice_id]
			self.quantity = raw_line[:quantity]
			self.unit_price = clean_unit_price(raw_line[:unit_price])
		end

		private

		def clean_unit_price(raw_data)
			BigDecimal(raw_data) / 100
		end
	end
end