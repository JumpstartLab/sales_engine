module SalesEngine
	class Merchant
  attr_accessor :records
  def items
  	# This will need to inherit from SalesEngine::Searchable
  	items ||= []
  end
  #Merchant.random

	end
end


