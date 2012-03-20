require './spec/spec_helper.rb'

describe Merchant do

	let (:test_merchant){ Merchant.new }
	
  describe "items" do

  	before(:each) do
  		test_merchant.items = ["item1", "item2", "item3"]
  	end

    it "returns a collection of items from this merchant" do
    	test_merchant.items.should == ["item1", "item2", "item3"]
    end
  end

  describe "invoices" do

    before(:each) do
      test_merchant.invoices = ["invoice1", "invoice2", "invoice3"]
    end

    it "returns a collection of inovices" do
      test_merchant.invoices.should == ["invoice1", "invoice2", "invoice3"]
    end
  end

end