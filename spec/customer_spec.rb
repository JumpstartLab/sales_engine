require './spec/spec_helper'

describe SalesEngine::Customer do
	describe ".get_customers" do
		before(:all) { SalesEngine::Customer.get_customers }
		it "stores records from customer.csv" do
			SalesEngine::Customer.records.map(&:class).uniq.should == [SalesEngine::Customer]
		end
		{id: 1, first_name: "Eliezer",
		last_name: "Lemke"}.each do |attribute, value|
			it "records #{attribute}" do
			  SalesEngine::Customer.records.first.send(attribute).should == value
		  end
		end
	end

	context "instance methods" do
		let(:customer) { SalesEngine::Customer.find_by_id(1) }
		describe "#invoices" do
			it "returns invoices" do
				customer.invoices.should_not be_empty
				customer.invoices.first.should be_a(SalesEngine::Invoice)
			end
			it "returns all invoices with the customer_id of the instance" do
				customer.invoices.size.should == 8
			end
		end
	end
end

#id,first_name,last_name,created_at,updated_at
#1,Lemke,Eliezer,2012-02-26 20:56:56 UTC,2012-02-26 20:56:56 UTC