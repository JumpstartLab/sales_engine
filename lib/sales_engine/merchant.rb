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

		def self.most_revenue(num_merchants)
			all.sort_by{|m| puts m.id; m.total_revenue}.first(num_merchants)
		end

		def initialize(raw_line)
			self.name = raw_line[:name]
			self.id = raw_line[:id].to_i
		end

		def items
			@items ||= SalesEngine::Item.find_all_by_merchant_id(self.id)
		end

		def invoices
			@invoices ||= SalesEngine::Invoice.find_all_by_merchant_id(self.id)
		end

		def total_revenue
			@total_revenue ||= invoices.map(&:total_paid).inject(:+)
		end
	end
end


