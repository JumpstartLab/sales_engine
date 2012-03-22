module SalesEngine
	class Customer
		extend Searchable
		attr_accessor :first_name, :last_name, :id

		def self.records
			Engine.instance.customers
		end

		def self.get_customers
			CSVLoader.load('data/customers.csv').collect do |record|
				Customer.new(record)
			end
		end

		def initialize(raw_line)
			self.first_name = raw_line[:first_name]
			self.last_name = raw_line[:last_name]
			self.id = raw_line[:id].to_i
		end

		def invoices
			@invoices ||= SalesEngine::Invoice.find_all_by_customer_id(self.id)
		end
	end
end