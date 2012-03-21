require 'csv'
require 'sales_engine'
require 'customer'
require 'transaction'
require 'merchant'
require 'item'
require 'invoice'
require 'invoice_item'

describe SalesEngine do
  describe "#initialize" do
    let(:test_sales_engine){ SalesEngine.new }
    it "creates a key => array pair for each data type" do
      test_sales_engine.data.keys.count.should == 6
    end
  end
end

