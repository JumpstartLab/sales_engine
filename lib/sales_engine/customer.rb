module SalesEngine
	class Customer
		attr_accessor :first_name, :last_name, :id

		def self.records
			@@records ||= []
		end

		def self.records=(value)
			@@records = value
		end

		def self.get_customers
			raw_records = SalesEngine::CSVLoader.load('data_files/customers.csv')
			self.records = raw_records.collect do |record|
				Customer.new(record)
			end
		end

		def initialize(raw_line)
			self.first_name = raw_line[:first_name]
			self.last_name = raw_line[:last_name]
			self.id = raw_line[:id]
		end
	end
end