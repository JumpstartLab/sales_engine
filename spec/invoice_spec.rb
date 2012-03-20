require './spec/spec_helper'

describe SalesEngine::Invoice do
	describe ".get_invoices" do
		before(:each) { SalesEngine::Invoice.get_invoices }
		it "stores records from invoice.csv in @@records" do
			SalesEngine::Invoice.records.map(&:class).uniq.should == [SalesEngine::Invoice]
		end
		it "stores an id" do
			SalesEngine::Invoice.records.first.id.should == '1'
		end
		it "stores a customer_id" do
			SalesEngine::Invoice.records.first.customer_id.should == "1"

		end
		it "stores a merchant_id" do
			SalesEngine::Invoice.records.first.merchant_id.should == "92"
		end
		it "stores a status" do
			SalesEngine::Invoice.records.first.status.should == "shipped"
		end

	end
end

#id,customer_id,merchant_id,status,created_at,updated_at
#1,1,92,shipped,2012-02-14 20:56:56 UTC,2012-02-26 20:56:56 UTC