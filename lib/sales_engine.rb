$LOAD_PATH.unshift("./lib")

require 'sales_engine/database'
require 'bigdecimal'

module SalesEngine

  def self.startup
    Database.instance
  end

end