require './spec/spec_helper'

describe SalesEngine::Customer do
	describe "#load" do
		before(:each) { SalesEngine::Customer.get_customers }
		it "stores records from customer.csv in @@records" do
			SalesEngine::Customer.records.map(&:class).uniq.should == [SalesEngine::Customer]
		end
		it "stores an id" do
			SalesEngine::Customer.records.first.id.should == '1'
		end
		it "stores a first_name" do
			pending
			SalesEngine::Customer.records.should be_an Array
		end
		it "stores a last_name" do
			pending
			SalesEngine::Customer.records.should be_an Array
		end
	end
end