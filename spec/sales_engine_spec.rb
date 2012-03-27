require 'spec_helper'
require 'sales_engine'

class DummySalesEngine

end

describe SalesEngine do
  describe '.startup' do
    it 'instantiates the Database' do
      SalesEngine::Database.instance
    end
  end
end