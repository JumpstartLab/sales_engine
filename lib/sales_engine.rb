$LOAD_PATH.unshift("./lib")

require 'sales_engine/database'
require 'bigdecimal'
require 'sales_engine/sanitize'

module SalesEngine

  def self.startup
    Database.instance
  end

end