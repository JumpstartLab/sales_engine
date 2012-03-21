module SalesEngine
	class Transaction
		attr_accessor :id, :invoice_id, :credit_card_number
		attr_accessor :credit_card_expiration_date, :result

		def self.records
			Engine.instance.transactions
		end

		def self.get_transactions
			CSVLoader.load('data_files/transactions.csv').collect do |record|
				Transaction.new(record)
			end
		end

		def initialize(raw_line)
			self.id = raw_line[:id]
			self.invoice_id = raw_line[:invoice_id]
			self.credit_card_number = raw_line[:credit_card_number]
			self.credit_card_expiration_date = raw_line[:credit_card_expiration_date]
			self.result = raw_line[:result]
		end


	end
end