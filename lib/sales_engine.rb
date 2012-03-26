#$LOAD_PATH.unshift(File.join(File.dirname(__FILE__),'lib')).uniq!
$LOAD_PATH.unshift("./lib")

require 'sales_engine/database'

module SalesEngine

  def self.startup
    Database.instance
  end

end