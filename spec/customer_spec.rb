require './spec/spec_helper'

describe SalesEngine::Customer do
	describe ".get_customers" do
		before(:all) { SalesEngine::Customer.get_customers }
		it "stores records from customer.csv" do
			SalesEngine::Customer.records.map(&:class).uniq.should == [SalesEngine::Customer]
		end
		{id: "1", first_name: "Lemke",
		last_name: "Eliezer"}.each do |attribute, value|
			it "records #{attribute}" do
			  SalesEngine::Customer.records.first.send(attribute).should == value
		  end
		end
	end
end

#id,first_name,last_name,created_at,updated_at
#1,Lemke,Eliezer,2012-02-26 20:56:56 UTC,2012-02-26 20:56:56 UTC