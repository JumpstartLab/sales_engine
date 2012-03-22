require 'spec_helper'

describe SalesEngine::Merchant do

  test_attributes = [:id => '1', :name => "Brekkle, Haley, and Wolff", :created_at => "2012-02-26 20:56:50 UTC", :updated_at => "2012-02-26 20:56:50 UTC"]
	let (:test_merchant){ SalesEngine::Merchant.new(test_attributes) }
	
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
