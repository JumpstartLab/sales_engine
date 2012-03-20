require './spec/spec_helper'

describe SalesEngine::Customer do
	describe ".get_customers" do
		before(:each) { SalesEngine::Customer.get_customers }
		it "stores records from customer.csv in @@records" do
			SalesEngine::Customer.records.map(&:class).uniq.should == [SalesEngine::Customer]
		end
		it "stores an id" do
			SalesEngine::Customer.records.first.id.should == '1'
		end
		it "stores a first_name" do
			SalesEngine::Customer.records.first.first_name.should == "Lemke"

		end
		it "stores a last_name" do
			SalesEngine::Customer.records.first.last_name.should == "Eliezer"
		end
	end
end