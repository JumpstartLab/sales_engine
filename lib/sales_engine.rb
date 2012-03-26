$LOAD_PATH.unshift("./lib")

require 'sales_engine/database'

module SalesEngine

  def self.startup
    Database.instance
  end

end