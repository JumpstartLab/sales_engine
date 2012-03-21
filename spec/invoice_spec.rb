require './spec/spec_helper'

describe SalesEngine::Invoice do
	describe ".get_invoices" do
		before(:all) { SalesEngine::Invoice.get_invoices }
		it "stores records from invoices.csv" do
			SalesEngine::Invoice.records.map(&:class).uniq.should == [SalesEngine::Invoice]
		end

		{id: "1", customer_id: "1",
		merchant_id: "92", status: "shipped"}.each do |attribute, value|
			it "records #{attribute}" do
			  SalesEngine::Invoice.records.first.send(attribute).should == value
		  end
	  end
	end
end
#id,customer_id,merchant_id,status,created_at,updated_at
#1,1,92,shipped,2012-02-14 20:56:56 UTC,2012-02-26 20:56:56 UTC