require './spec/spec_helper'

describe SalesEngine do
  let(:se) { SalesEngine.instance }

  before(:each) do
    se.clear_all_data
  end

  describe "#load_merchants_data" do
    it "reads in merchant data from a file & stores the result as a merchant master list" do
      se.load_merchants_data('./test/data/merchants.csv')
      se.merchants.count.should == 3
    end
  end

  describe "#load_items_data" do
    it "reads in item data from a file & stores the result as an item master list" do
      se.load_items_data('./test/data/items.csv')
      se.items.count.should == 2
    end
  end

  describe "#load_invoices_data" do
    it "reads in invoice data from a file & stores the result as an invoice master list" do
      se.load_invoices_data('./test/data/invoices.csv')
      se.invoices.count.should == 4
    end
  end

  describe "#add_to_list" do
    it "allows you to add a new object to the appropriate master list" do
      se.add_to_list(Merchant.new)
      se.merchants.count.should == 1
    end
  end
end