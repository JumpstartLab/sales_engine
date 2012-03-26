require 'csv'
require 'sqlite3'


class Loader 
  attr_accessor :database 

  def initialize(database)
    self.database = database
  end 

  def load
    load_merchants
    load_items
    load_customers
    load_invoices
    load_invoice_items
    load_transactions
  end

  private 

  def load_merchants
    database.execute %Q{ 
      CREATE TABLE merchants ( 
      id integer primary key, 
      name text,
      created_at text, 
      updated_at text);
    }

    file = CSV.open("../data/merchants.csv", {:headers => true, :header_converters => :symbol})
    file.each do |line|
      database.execute("insert into merchants values (?, ?, ?, ?)",
                       line[:id].to_i, line[:name], line[:created_at], line[:updated_at])
    end
  end

  def load_items
    database.execute %Q{ 
      CREATE TABLE items ( 
      id integer primary key, 
      name text,
      description text,
      unit_price integer,
      merchant_id integer,
      created_at text, 
      updated_at text,
      foreign key(merchant_id) references merchant(id));
    }

    file = CSV.open("../data/items.csv", {:headers => true, :header_converters => :symbol})
    file.each do |line|
      database.execute("insert into items values (?, ?, ?, ?, ?, ?, ?)",
                       line[:id].to_i, line[:name], line[:description], 
                       line[:unit_price].to_i, line[:merchant_id].to_i,
                       line[:created_at], line[:updated_at])
    end
  end

  def load_customers
    database.execute %Q{ 
      CREATE TABLE customers ( 
      id integer primary key, 
      first_name text,
      last_name text,
      created_at text, 
      updated_at text)
    }

    file = CSV.open("../data/customers.csv", {:headers => true, :header_converters => :symbol})
    file.each do |line|
      database.execute("insert into customers values (?, ?, ?, ?, ?)",
                       line[:id].to_i, line[:first_name], line[:last_name], 
                       line[:created_at], line[:updated_at])
    end
  end

  def load_invoices
    database.execute %Q{ 
      CREATE TABLE invoices ( 
      id integer primary key, 
      customer_id integer,
      merchant_id integer,
      status text,
      created_at text, 
      updated_at text,
      foreign key(merchant_id) references merchants(id));
      foreign key(customer_id) references customers(id));
    }

    file = CSV.open("../data/invoices.csv", {:headers => true, :header_converters => :symbol})
    file.each do |line|
      database.execute("insert into invoices values (?, ?, ?, ?, ?, ?)",
                       line[:id].to_i, line[:customer_id].to_i, line[:merchant_id].to_i, 
                       line[:status], line[:created_at], line[:updated_at])
    end
  end


  def load_invoice_items
    database.execute %Q{ 
      CREATE TABLE invoice_items ( 
      id integer primary key, 
      item_id integer,
      invoice_id integer,
      quantity integer,
      unit_price integer,
      created_at text, 
      updated_at text,
      foreign key(item_id) references items(id));
      foreign key(invoice_id) references invoices(id));
    }

    file = CSV.open("../data/invoice_items.csv", {:headers => true, :header_converters => :symbol})
    file.each do |line|
      database.execute("insert into invoice_items values (?, ?, ?, ?, ?, ?, ?)",
                       line[:id].to_i, line[:item_id].to_i, line[:invoice_id].to_i, 
                       line[:quantity].to_i, line[:unit_price].to_i, 
                       line[:created_at], line[:updated_at])
    end
  end


  def load_transactions
    database.execute %Q{ 
      CREATE TABLE transactions ( 
      id integer primary key, 
      invoice_id integer,
      credit_card_number text,
      credit_card_expiration_date text,
      result text,
      created_at text, 
      updated_at text,
      foreign key(invoice_id) references invoices(id));
    }

    file = CSV.open("../data/transactions.csv", {:headers => true, :header_converters => :symbol})
    file.each do |line|
      database.execute("insert into transactions values (?, ?, ?, ?, ?, ?, ?)",
                       line[:id].to_i, line[:invoice_id].to_i, line[:credit_card_number],
                       line[:credit_card_expiration_date], line[:result],
                       line[:created_at], line[:updated_at])
    end
  end
end


#Loader.new(SQLite3::Database.new(':memory:')).load
