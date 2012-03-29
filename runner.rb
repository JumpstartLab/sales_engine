require 'date'
require 'awesome_print'
require './lib/sales_engine'

SalesEngine.startup


cust = SalesEngine::Customer.find_by_id(1)

ap cust.days_since_activity


# most = SalesEngine::Item.most_items(42)
# ap most[0].items_sold
# ap most[-1].items_sold
# test2 = SalesEngine::Item.find_by_id("1704")
# ap test2.items_sold


##############################################################################
          # Customer.most_revenue
##############################################################################

# test = SalesEngine::Customer.find_by_id("75")
# ap test.total_spent
# ap SalesEngine::Customer.most_revenue.total_spent
# 16634950.0 =>  total spent for customer 75
# 19064845.0 => total spent by biggest spender

##############################################################################
          # Customer.most_items
##############################################################################

# ap SalesEngine::Customer.most_items.items_purchased
# 354 => most items purchased by a customer
# id=\"75\", @first_name=\"Cole\", @last_name=\"Deshaun\" <= info for customer

##############################################################################
          # Customer#pending_invoices
##############################################################################

# SalesEngine::Invoice.create({:id => "5001", :status => "pending", :customer_id => "25", :merchant_id => "15"})

# ap SalesEngine::Customer.find_by_id("25").pending_invoices
# [
#     [0] #<SalesEngine::Invoice:0x7ff77515c998
#         attr_accessor :customer_id = "25",
#         attr_accessor :id = "5001",
#         attr_accessor :merchant_id = "15",
#         attr_accessor :status = "pending",
#         attr_reader :transactions = []
#     >
# ]

##############################################################################
          # Customer#days_since_activity
##############################################################################

# SalesEngine::Transaction.new({:invoice_id => "2", :created_at => "2012-03-15"})
# ap SalesEngine::Customer.find_by_id("1").days_since_activity
# #<SalesEngine::Transaction:0x7fd55e136d08
#     attr_accessor :created_at = #<Date: 2012-03-15 ((2456002j,0s,0n),+0s,2299161j)>,
#     attr_accessor :invoice_id = "2"
# >
# 12

##############################################################################
          # Invoice.average_items(date)
##############################################################################

# SalesEngine::Invoice.average_items(Date.parse("2012-02-15"))
# 6315 => average items amongst invoices w/ transactions on that day
# 260 => invoices with transactions on that day

##############################################################################
          # Invoice.average_revenue(date)
##############################################################################

# ap SalesEngine::Invoice.average_revenue(Date.parse("2012-02-15"))
# 311307471 (total revenue for Feb-15)
# 246 (invoices)
# 1265477 (average revenue for Feb 15)

##############################################################################
          # Invoice.average_revenue
##############################################################################

# ap SalesEngine::Invoice.average_revenue
# 0.6153883021E10 (total_revenue)
# 4985 (invoices)
# 1234480.044332999 (average)

##############################################################################
          # Merchant#customers_with_pending_invoices
##############################################################################

# SalesEngine::Invoice.create({:id => "5001", :status => "pending", :customer_id => "25", :merchant_id => "15"})
# test_merchant = SalesEngine::Merchant.find_by_id("15")

# ap test_merchant.customers_with_pending_invoices
# --> returns customer with id "25"
# #     [0] #<SalesEngine::Customer:0x7fd73329c130
#         attr_accessor :created_at = #<Date: 2012-02-26 ((2455984j,0s,0n),+0s,2299161j)>,
#         attr_accessor :first_name = "Monahan",
#         attr_accessor :id = "25",
#         attr_accessor :last_name = "Brianne",
#         attr_accessor :updated_at = #<Date: 2012-02-26 ((2455984j,0s,0n),+0s,2299161j)>
#     >

##############################################################################
          # Merchant.revenue(date) && Merchant.revenue(date_range)
##############################################################################

# # ap SalesEngine::Merchant.revenue(Date.parse("2012-02-15"))
# 326543512.0 =>revenue for Feb 15
# # ap SalesEngine::Merchant.revenue(Date.parse("2012-02-16"))
# 311307471.0 => revenue for Feb 16
# # ap SalesEngine::Merchant.revenue(Date.parse("2012-02-15"), Date.parse("2012-02-16"))
# 637850983.0 => revenue for Feb 15 & 16