## Classes

### Data items
Merchant
	#items - returns a collction of Item associated with the merchant
	#invoices - returns collection of Invoice instances
Invoice
	#transactions returns Transactions
	#invoice_items returns InvoiceItem
	#items returns a collection of Items by way of /InvoiceItem objects/
	#customer returns a instance of Customer associated with this invoice
Item
	#invoice_items returns instance of InvoiceItems
	#merchant returns instance of Merchant
Transaction
	#returns the invoice associated with the transaction
Customer
	#invoices returns a list of all of their invoices
InvoiceItem
	#invoice return instance of Invoice
	#item return instance of item

### Other Items
Sales_engine
	* Called when you start up, initiates the database.
	* has reference to database

Database
	* implemented as a singleton
	* has arrays containing the 6 data items
	* can load data from csv

### Overall class structure

Import data (from Merchants/Items)
* create Merchants
* create Invoice
* create Items
* create Transaction
* create Customer

invoice = Invoice.new(:customer_id => customer, :merchant_id => merchant, :status => "shipped", :items => [item1, item2, item3], :transaction => transaction)

### outstanding questions
* Class method .find_by_X(match) should this search the array that our SalesEngine stores, 