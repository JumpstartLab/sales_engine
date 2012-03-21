require 'singleton'

class Database
  include Singleton

  attr_accessor :transaction_list 

  def initialize
    self.transaction_list = []
  end

end