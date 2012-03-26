module SalesEngine
	class Item
		extend Searchable
		attr_accessor :name, :id, :description, :unit_price, :merchant_id, :total_revenue, :items_sold

		def self.records
			@items ||= get_items
		end

		def self.get_items
			CSVLoader.load('data/items.csv').collect do |record|
				Item.new(record)
			end
		end

		def self.most_revenue(num_items)
			all.sort_by{|i| i.total_revenue}.first(num_items)
		end

		def self.most_items(num_items)
			all.sort_by{|i| i.items_sold}.first(num_items)
		end

		def initialize(raw_line)
			self.name = raw_line[:name]
			self.id = raw_line[:id].to_i
			self.description = raw_line[:description]
			self.merchant_id = raw_line[:merchant_id].to_i
			self.unit_price = clean_unit_price(raw_line[:unit_price])
			self.total_revenue = 0
			self.items_sold = 0
		end

		def invoice_items
			@invoice_items ||= SalesEngine::InvoiceItem.find_all_by_item_id(self.id)
		end

		def merchant
			@merchant ||= SalesEngine::Merchant.find_by_id(self.merchant_id)
		end

		def best_day
		end

		private

		def clean_unit_price(raw_data)
			BigDecimal(raw_data) / 100
		end

	end
end