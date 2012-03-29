 module SalesEngine
  require 'sales_engine/dynamic_finder'
  class Customer
    attr_accessor :id, :first_name, :last_name, :created_at, :updated_at,
                  :customer_invs

    CUSTOMER_ATTS = [
     "id",
     "first_name",
     "last_name",
     "created_at",
     "updated_at"
     ]

    def initialize(attrs)
      self.id = Cleaner::fetch_id("customer", attrs[:id])
      self.first_name = attrs[:first_name]
      self.last_name = attrs[:last_name]
      self.created_at = Cleaner::fetch_date(attrs[:created_at])
      self.updated_at = Cleaner::fetch_date(attrs[:updated_at])

      SalesEngine::Database.instance.customer_list << self
      SalesEngine::Database.instance.customer_id_hash[ self.id ] = self
    end

    def self.attributes_for_finders
      CUSTOMER_ATTS
    end

    extend SalesEngine::DynamicFinder

    def invoices
      customer_invs ||= SalesEngine::Invoice.find_all_by_customer_id(self.id)
    end

    def paid_invoices
      invoices.select { |inv| inv.is_successful? }
    end

    def days_since_activity
      invoice_array = paid_invoices.sort_by do |inv|
                              inv.created_at
                            end
      latest_invoice = invoice_array.reverse.first
      last_purchase_date = Date.parse(latest_invoice.created_at.to_s)
      ( Date.today - last_purchase_date )
    end

    def transactions
      trans_results = Array.new
      self.invoices.each do |invoice|
        inv_trans = SalesEngine::Transaction.find_all_by_invoice_id(invoice.id)
        trans_results.concat( inv_trans )
      end
      trans_results
    end

    def pending_invoices
      #Needs to do it uncached way b/c of Yoho's tests.
      invoices.select do |inv|
        inv.transactions.none? { |trans| trans.result == "success" }
      end
    end

    def self.paid_invoice_items
      SalesEngine::InvoiceItem.successful_invoice_items
    end

    def self.customers_by_items_bought
      item_data = { }

      paid_invoice_items.each do |invoice_item|
        item_data[ invoice_item.invoice.customer_id ] ||= 0
        item_data[ invoice_item.invoice.customer_id ] += invoice_item.quantity
      end
      item_data
    end

    def self.most_items
      item_data = customers_by_items_bought.sort_by do |customer_id, quantity|
        -quantity
      end

      top_customer_id = item_data.first[0]
      find_by_id(top_customer_id)
    end

    def self.paid_invoices
      SalesEngine::Invoice.successful_invoices
    end

    def self.customers_by_revenue_bought
      revenue_data = { }

      paid_invoices.each do |inv|
        revenue_data[ inv.customer_id ] ||= 0
        revenue_data[ inv.customer_id ] += inv.invoice_revenue
      end
      revenue_data
    end

    def self.most_revenue
      revenue_data = customers_by_revenue_bought.sort_by do |c_id, revenue|
        -revenue
      end

      top_customer_id = revenue_data.first[0]
      find_by_id(top_customer_id)
    end

    def merchant_paid_invoice_count
      paid_invoice_count = { }

      paid_invoices.each do |invoice|
        paid_invoice_count[ invoice.merchant_id ] ||= 0
        paid_invoice_count[ invoice.merchant_id ] += 1
      end
      paid_invoice_count
    end

    def favorite_merchant
      merchant_data_max = merchant_paid_invoice_count.max_by{ |k, v| v }
      return nil if merchant_data_max.nil?
      SalesEngine::Merchant.find_by_id(merchant_data_max.first)
    end

  end
end