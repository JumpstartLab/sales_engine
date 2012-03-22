module SalesEngine
	class Merchant
		extend SalesEngine::Searchable
		attr_accessor :name, :id

		def self.records
			Engine.instance.merchants
		end

		def self.get_merchants
		  CSVLoader.load('data/merchants.csv').collect do |record|
				Merchant.new(record)
			end
		end

		def initialize(raw_line)
			self.name = raw_line[:name]
			self.id = raw_line[:id]
		end

		def items
			SalesEngine::Item.find_all_by_merchant_id(self.id)
		end

		def invoices
			SalesEngine::Invoice.find_all_by_merchant_id(self.id)
		end
	end
end


