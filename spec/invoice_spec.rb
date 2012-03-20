require './spec/spec_helper'

describe SalesEngine::Invoice do
	describe "#customer_id" do
		it "responds to a setter" do
			invoice = SalesEngine::Invoice.new
			invoice.customer_id = 1
			invoice.customer_id.should == 1
		end
	end

end