$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'lib')).uniq!

require 'simplecov'
SimpleCov.start do
  add_filter "/spec/"
end

require 'date'
require 'bigdecimal'
require 'fabrication'
require 'faker'
require 'sqlite3'

require 'sales_engine'

sqlite_db = SQLite3::Database.new(':memory:')
Loader.new(sqlite_db).load
SalesEngine::Database.instance.db = sqlite_db
