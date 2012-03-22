require 'csv'
require 'sales_engine'
require 'customer'
require 'transaction'
require 'merchant'
require 'item'
require 'invoice'
require 'invoice_item'

describe SalesEngine::SalesEngine do
  describe "#initialize" do
    let(:classes) do
      [:customer, :item, :invoice_item, :merchant, :transaction, :invoice]
    end
    let(:test_sales_engine){ SalesEngine::SalesEngine.new }
    it "creates a key => array pair for each data type" do
      classes.each do |klass|
        Database.instance.send(klass).count.should_not == 0
      end
    end
  end
end

