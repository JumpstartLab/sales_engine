module SalesEngine
	class Customer
		attr_accessor :first_name, :last_name, :id

		def self.records
			Engine.instance.customers
		end

		def self.get_customers
			CSVLoader.load('data_files/customers.csv').collect do |record|
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