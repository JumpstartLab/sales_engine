module SalesEngine
	class Item
		extend Searchable
		attr_accessor :name, :id, :description, :unit_price, :merchant_id

		def self.records
			@items ||= get_items
		end

		def self.get_items
			CSVLoader.load('data/items.csv').collect do |record|
				Item.new(record)
			end
		end

		def initialize(raw_line)
			self.name = raw_line[:name]
			self.id = raw_line[:id].to_i
			self.description = raw_line[:description]
			self.merchant_id = raw_line[:merchant_id].to_i
			self.unit_price = clean_unit_price(raw_line[:unit_price])
		end

		def invoice_items
			@invoice_items ||= SalesEngine::InvoiceItem.find_all_by_item_id(self.id)
		end

		def merchant
			@merchant ||= SalesEngine::Merchant.find_by_id(self.merchant_id)
		end

		private

		def clean_unit_price(raw_data)
			BigDecimal(raw_data) / 100
		end

	end
end