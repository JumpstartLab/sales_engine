require './spec/spec_helper'

describe SalesEngine::Merchant do
	describe ".get_merchants" do
		before(:all) { SalesEngine::Merchant.get_merchants }
		it "stores records from merchants.csv" do
			SalesEngine::Merchant.records.map(&:class).uniq.should == [SalesEngine::Merchant]
		end

		{id: 1, name: "Brekke, Haley and Wolff"}.each do |attribute, value|
			it "records #{attribute}" do
				SalesEngine::Merchant.records.first.send(attribute).should == value
			end
		end
	end

	context "instance methods" do
		let(:merchant) { SalesEngine::Merchant.find_by_id(1) }
		describe "#items" do
			it "returns items" do
				merchant.items.should_not be_empty
				merchant.items.first.should be_a(SalesEngine::Item)
			end
			it "returns all items with the merchant_id of the instance" do
				merchant.items.size.should == 21
			end
		end
		describe "#invoices" do
			it "returns invoices" do
				merchant.invoices.should_not be_empty
				merchant.invoices.first.should be_a(SalesEngine::Invoice)
			end
			it "returns all invoices with the merchant_id of the instance" do
				merchant.invoices.size.should == 51
			end
		end
		describe "#total_revenue" do
			it "returns the total revenue for the merchant" do
				merchant.total_revenue.should == BigDecimal("512254.82")
			end
		end
	end

	context "business intelligence methods" do
		describe ".most_revenue" do
			it "returns an array of Merchants" do
				SalesEngine::Merchant.most_revenue(1).first.should be_a(SalesEngine::Merchant)
			end
			it "returns merchants sorted by descending revenue" do
				merch_a = SalesEngine::Merchant.find_by_id(54)
				merch_b = SalesEngine::Merchant.find_by_id(7)
				merch_c = SalesEngine::Merchant.find_by_id(58)
				SalesEngine::Merchant.most_revenue(3).should == [ merch_a, merch_b, merch_c ]
			end
		end
		describe ".most_items" do
			it "returns an array of Merchants" do
				SalesEngine::Merchant.most_items(1).first.should be_a(SalesEngine::Merchant)
			end
			it "returns merchants sorted by descending items sold" do
				merch_a = SalesEngine::Merchant.find_by_id(6)
				merch_b = SalesEngine::Merchant.find_by_id(93)
				merch_c = SalesEngine::Merchant.find_by_id(85)
				SalesEngine::Merchant.most_items(3).should == [ merch_a, merch_b, merch_c ]
			end
		end

		describe "#revenue" do
			it "returns the total revenue for a merchant" do
				SalesEngine::Merchant.find_by_id(54).revenue.should == BigDecimal("276580.96")
			end
		end
		describe "#revenue(date)" do
			it "returns the total revenue for a merchant on a specific date" do
				SalesEngine::Merchant.find_by_id(54).revenue(DateTime.parse("2012-02-26 20:56:50 UTC")).should == BigDecimal("13121.86")
			end
		end
	end

end

#id,name,created_at,updated_at
#1,"Brekke, Haley and Wolff",2012-02-26 20:56:50 UTC,2012-02-26 20:56:50 UTC