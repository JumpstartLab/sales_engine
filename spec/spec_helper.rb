$LOAD_PATH << './'
$LOAD_PATH << './lib/sales_engine'
$LOAD_PATH << './data'
require 'simplecov'
SimpleCov.start do
  add_filter "/spec/"
end
require 'sales_engine'
extend SalesEngine
# module CommonLets
#   def self.extended(base)
#     base.let!(:sales_engine) {SalesEngine.new}
#     base.let(:customer) {Customer.random}
#     base.let(:merchant) {Merchant.random}
#     base.let(:invoice) {Invoice.random}
#     base.let(:item) {Item.random}
#     base.let(:transaction) {Transaction.random}
#     base.let(:invoice_item) {InvoiceItem.random}
#   end
# end