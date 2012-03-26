require './lib/sales_engine/database'

module Find

  def find_customers(attribute, match)
    puts "finding #{match} for #{attribute}"
    SalesEngine::Database.instance.customers.find do |c| 
      c.send(attribute.to_sym) == match
    end
  end

  def find_all_customers(attribute, match)
    puts "finding all #{match} for #{attribute}"
    SalesEngine::Database.instance.customers.select do |c| 
      c.send(attribute.to_sym) == match
    end
  end

  def find_invoices(attribute, match)
    SalesEngine::Database.instance.invoices.find do |i|
      i.send(attribute.to_sym) == match
    end
  end

  def find_all_invoices(attribute, match)
    SalesEngine::Database.instance.invoices.select do |i|
      i.send(attribute.to_sym) == match
    end
  end

  def find_invoice_items(attribute, match)
    SalesEngine::Database.instance.invoice_items.find do |ii|
      ii.send(attribute.to_sym) == match
    end
  end

  def find_all_invoice_items(attribute, match)
    SalesEngine::Database.instance.invoice_items.select do |ii|
      ii.send(attribute.to_sym) == match
    end
  end

  def find_items(attribute, match)
    SalesEngine::Database.instance.items.find do |i|
      i.send(attribute.to_sym) == match
    end
  end

  def find_all_items(attribute, match)
    SalesEngine::Database.instance.items.select do |i|
      i.send(attribute.to_sym) == match
    end
  end

  def find_merchants(attribute, match)
    puts "finding #{match} for #{attribute}"
    SalesEngine::Database.instance.merchants.find do |m|
      m.send(attribute.to_sym) == match
    end
  end

  def find_all_merchants(attribute, match)
    SalesEngine::Database.instance.merchants.select do |m|
      m.send(attribute.to_sym) == match
    end
  end

  def find_transactions(attribute, match)
    SalesEngine::Database.instance.transactions.find do |t|
      t.send(attribute.to_sym) == match
    end
  end

  def find_all_transactions(attribute, match)
    SalesEngine::Database.instance.transactions.select do |t|
      t.send(attribute.to_sym) == match
    end
  end

end