module SalesEngine
	class Merchant
		attr_accessor :name, :id

		def self.records
			@@records ||= []
		end

		def self.records=(value)
			@@records = value
		end

		def self.get_merchants
			raw_records = SalesEngine::CSVLoader.load('data_files/merchants.csv')
			self.records = raw_records.collect do |record|
				Merchant.new(record)
			end
		end

		def initialize(raw_line)
			self.name = raw_line[:name]
			self.id = raw_line[:id]
		end

	end
end


