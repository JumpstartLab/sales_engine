require 'sqlite3'
database = SQLite3::Database.new('/Users/austenito/Desktop/sample.db')

qs = "select * from invoice_items where invoice_id in (select id from invoices 
      where merchant_id = 1)"
database.execute(qs)  do |row| 
  puts row.inspect
end

