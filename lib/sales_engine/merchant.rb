module SalesEngine
	class Merchant
		attr_accessor :name, :id

		def self.records
			Engine.instance.merchants
		end

		def self.get_merchants
		  CSVLoader.load('data_files/merchants.csv').collect do |record|
				Merchant.new(record)
			end
		end

		def initialize(raw_line)
			self.name = raw_line[:name]
			self.id = raw_line[:id]
		end

	end
end


