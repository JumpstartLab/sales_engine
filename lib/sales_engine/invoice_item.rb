module SalesEngine
	class InvoiceItem
		extend Searchable
		attr_accessor :id, :item_id, :invoice_id, :quantity, :unit_price, :line_total

		def self.records
			@invoice_items ||= get_invoice_items
		end

		def self.get_invoice_items
			CSVLoader.load('data/invoice_items.csv').collect do |record|
				InvoiceItem.new(record)
			end
		end

		def self.populate_merchant_revenues
	    records.each do |record|
	    	record.merchant.total_revenue += record.quantity * record.unit_price
	    	record.merchant.items_sold += 1
	    end
		end

		def initialize(raw_line)
			self.id = raw_line[:id].to_i
			self.item_id = raw_line[:item_id].to_i
			self.invoice_id = raw_line[:invoice_id].to_i
			self.quantity = raw_line[:quantity].to_i
			self.unit_price = clean_unit_price(raw_line[:unit_price])
			self.line_total = quantity * unit_price
		end

		def merchant
			@merchant ||= SalesEngine::Merchant.find_by_id(invoice.merchant_id)
		end

		def invoice
			@invoice ||= SalesEngine::Invoice.find_by_id(self.invoice_id)
		end

		def item
			@item ||= SalesEngine::Item.find_by_id(self.item_id)
		end

		private

		def clean_unit_price(raw_data)
			BigDecimal(raw_data) / 100
		end
	end
end