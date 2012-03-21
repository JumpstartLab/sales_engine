$LOAD_PATH.unshift("./")
require 'bigdecimal'

require 'sales_engine/searchable/searchable'
require 'sales_engine/customer'
require 'sales_engine/invoice'
require 'sales_engine/invoice_item'
require 'sales_engine/merchant'
require 'sales_engine/item'
require 'sales_engine/transaction'
require 'sales_engine/csv_loader'
require 'singleton'

module SalesEngine
	class Engine
		include Singleton

		attr_accessor :merchants, :items, :invoice_items
		attr_accessor :invoices, :customers, :transactions

		def initialize
			@merchants = Merchant.get_merchants
			@items = Item.get_items
			@invoice_items = InvoiceItem.get_invoice_items
			@invoices = Invoice.get_invoices
			@customers = Customer.get_customers
			@transactions = Transaction.get_transactions
		end

	end

end
