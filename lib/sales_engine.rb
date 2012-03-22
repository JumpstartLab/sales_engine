require './lib/sales_engine/database'

class SalesEngine

  def self.startup
    Database.instance
  end

end