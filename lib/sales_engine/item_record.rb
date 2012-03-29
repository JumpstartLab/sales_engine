module SalesEngine
  module ItemRecord
    def items
      items = []
      Database.instance.db.execute("select * from items") do |row|
        items << Item.new(row[0].to_i, row[1], row[2], row[3].to_f,
                          row[4].to_i, row[5], row[6])
      end
      items
    end

    def most_revenue(total_items)
      query = "SELECT item_id, SUM(quantity * unit_price) as sum
            FROM invoice_items
            INNER JOIN invoices ON invoice_items.invoice_id = invoices.id
            INNER JOIN transactions on invoices.id = transactions.invoice_id
            AND transactions.result LIKE 'success'
            GROUP BY item_id ORDER BY sum DESC LIMIT #{total_items}"
      items = []
      Database.instance.db.execute(query)  do |row|
        items << Item.find_by_id(row[0])
      end
      items
    end

    def most_items(total_items)
      query = "SELECT item_id, SUM(quantity) as sum FROM invoice_items
            INNER JOIN invoices ON invoice_items.invoice_id = invoices.id
            INNER JOIN transactions on invoices.id = transactions.invoice_id
            AND transactions.result LIKE 'success'
            GROUP BY item_id ORDER BY sum DESC LIMIT #{total_items}"
      items = []
      Database.instance.db.execute(query)  do |row|
        items << Item.find_by_id(row[0])
      end
      items
    end

    private

    def create_item(row)
      id = row[0].to_i
      name = row[1]
      description = row[2]
      unit_price = row[3].to_f/100
      merchant_id = row[4].to_i
      created_at = row[5]
      updated_at = row[6]
      Item.new(id, name, description, unit_price, merchant_id,
               created_at, updated_at)
    end
  end
end
