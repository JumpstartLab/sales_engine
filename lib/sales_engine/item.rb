module SalesEngine
	class Item
		extend Searchable
		attr_accessor :name, :id, :description, :unit_price, :merchant_id

		def self.records
			Engine.instance.items
		end

		def self.get_items
			CSVLoader.load('data_files/items.csv').collect do |record|
				Item.new(record)
			end
		end

		def initialize(raw_line)
			self.name = raw_line[:name]
			self.id = raw_line[:id]
			self.description = raw_line[:description]
			self.merchant_id = raw_line[:merchant_id]
			self.unit_price = clean_unit_price(raw_line[:unit_price])
		end

		private

		def clean_unit_price(raw_data)
			BigDecimal(raw_data) / 100
		end

	end
end