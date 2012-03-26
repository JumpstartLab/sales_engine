module SalesEngine
	class Merchant
		extend SalesEngine::Searchable
		attr_accessor :name, :id, :total_revenue, :items_sold

		def self.records
			@merchants ||= get_merchants
		end

		def self.get_merchants
			CSVLoader.load('data/merchants.csv').collect do |record|
				Merchant.new(record)
			end
		end

		def self.most_revenue(num_merchants)
			all.sort_by{|m| m.total_revenue}.first(num_merchants)
		end

		def self.most_items(num_merchants)
			all.sort_by{|m| m.items_sold}.first(num_merchants)
		end

		def self.revenue(date = nil)
			all.map{|m| m.revenue(date)}.inject(:+)
		end

		def initialize(raw_line)
			self.name = raw_line[:name]
			self.id = raw_line[:id].to_i
			self.total_revenue = 0
			self.items_sold = 0
		end

		def items
			@items ||= SalesEngine::Item.find_all_by_merchant_id(self.id)
		end

		def invoices
			@invoices ||= SalesEngine::Invoice.find_all_by_merchant_id(self.id)
		end

		def revenue(date = nil)
			if date
				dated_invoices = invoices.select { |i| i.created_at.strftime("%d%m%y") == date.strftime("%d%m%y") }
				dated_invoices.flat_map(&:invoice_items).map(&:line_total).inject(:+) || 0
			else
				@total_revenue || 0
			end
		end

		def favorite_customer
			SalesEngine::Customer.find_by_id(invoices.group_by{|i| i.customer_id}.sort_by{|i| i.last.size}.reverse.first.first)
		end

	end
end


