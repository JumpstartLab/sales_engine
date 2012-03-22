require 'singleton'

module SalesEngine
  class Database
    include Singleton

    attr_accessor :merchants, :customers, :items, :invoices, :invoice_items, :transactions
  end
end