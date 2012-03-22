$LOAD_PATH.unshift("./", './lib/')
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

	def self.startup
		# Hi, Jeff!
	end

	def self.extended(extending_caller)
		Customer.get_customers
		Merchant.get_merchants
		Item.get_items
		InvoiceItem.get_invoice_items
		Transaction.get_transactions
		Invoice.get_invoices
		InvoiceItem.populate_merchant_revenues
	end

end

extend SalesEngine