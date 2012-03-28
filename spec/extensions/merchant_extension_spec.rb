require 'spec_helper'

describe SalesEngine::Merchant, merchant: true do
  context "extensions" do
    describe ".dates_by_revenue" do
      it  "returns an array of Dates in descending order of revenue" do
        dates = SalesEngine::Merchant.dates_by_revenue

        dates.first.should == DateTime.parse("2012-03-09")
        dates[21].should == DateTime.parse("2012-03-06")
      end
    end

    describe ".dates_by_revenue(x)" do
      it  "returns the top x Dates in descending order of revenue" do
        dates = SalesEngine::Merchant.dates_by_revenue(5)

        dates.size.should == 5
        dates[1].should == DateTime.parse("2012-03-08")
        dates.last.should == DateTime.parse("2012-03-15")
      end
    end

    describe ".revenue(range_of_dates)" do
      it "returns the total revenue for all merchants across several dates" do
        date_1 = DateTime.parse("2012-03-14")
        date_2 = DateTime.parse("2012-03-16")
        revenue = SalesEngine::Merchant.revenue(date_1..date_2)

        revenue.should == BigDecimal("8226179.74")
      end
    end

    describe "#revenue(range_of_dates)" do
      it "returns the total revenue for that merchant across several dates" do
        date_1 = DateTime.parse("2012-03-01")
        date_2 = DateTime.parse("2012-03-07")
        merchant = SalesEngine::Merchant.find_by_id(7)
        revenue = merchant.revenue(date_1..date_2)

        revenue.should == BigDecimal("57103.77")
      end
    end
  end
end