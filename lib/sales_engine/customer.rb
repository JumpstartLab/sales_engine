module SalesEngine
	class Customer
		extend Searchable
		attr_accessor :first_name, :last_name, :id

		def self.records
			@customers ||= get_customers
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

		def transactions
			invoices.flat_map(&:transactions)
		end

		def favorite_merchant
			SalesEngine::Merchant.find_by_id(invoices.group_by{|i| i.merchant_id}.sort_by{|i| i.last.size}.last.first)
		end
	end
end