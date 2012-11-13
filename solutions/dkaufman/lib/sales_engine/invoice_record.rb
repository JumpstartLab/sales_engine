module SalesEngine
  module InvoiceRecord
     def invoices
       invoices = []
       Database.instance.db.execute("select * from invoices") do |row|
         invoices << Invoice.new(row[0], row[1], row[2], row[3],
                                  row[4], row[5])
       end
       invoices
     end

      def for_merchant(merchant_id)
       invoices = []
       query = "select * from invoices
                where merchant_id = #{merchant_id}"
       Database.instance.db.execute(query)  do |row|
         invoices << create_invoice(row)
       end
      invoices
     end

     def for_merchant_and_date(merchant_id, date)
       invoices = []
       query = "SELECT * FROM invoices
       WHERE merchant_id = 1
       AND Date(invoices.created_date) = Date('#{date.to_s}')"
       Database.instance.db.execute(query)  do |row|
        invoices << create_invoice(row)
       end
       invoices
     end

     def insert(hash)
      raw_date, clean_date = Database.get_dates
      Database.instance.db.execute(
                  "insert into invoices values (?, ?, ?, ?, ?, ?, ?, ?)",
                  nil, hash[:customer_id].to_i, hash[:merchant_id].to_i,
                  hash[:status], raw_date.to_s, raw_date.to_s,
                  clean_date, clean_date)
      return Database.instance.db.last_insert_row_id
     end

     def pending
       query = "select invoice_id, result from transactions
               INNER JOIN invoices on transactions.invoice_id = invoices.id"
       pending_invoices = []
       Database.instance.db.execute(query)  do |row|
         invoice_id = row[0]
         if row[1] == "success"
           pending_invoices.delete(invoice_id)
         else
           pending_invoices << invoice_id
         end
      end

      pending_invoices.collect { |id| Invoice.find_by_id(id) }
     end

     private

     def create_invoice(row)
       id = row[0]
       customer_id = row[1]
       merchant_id = row[2]
       status = row[3]
       created_at = row[5]
       updated_at = row[6]
       Invoice.new(id, customer_id, merchant_id, status,
                       created_at, updated_at)
     end
  end
end
