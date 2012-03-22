require 'singleton'

module SalesEngine
  class Database
    include Singleton

    attr_accessor :transaction_list, :customer_list, :item_list, :merchant_list,
      :invoice_item_list, :invoice_list

    def initialize
      self.transaction_list = []
      self.invoice_list = []
    end
  end
end