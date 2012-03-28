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

    # it "stores the raw CSV for each merchant" do
    #   SalesEngine::Merchant.records.first.raw_csv.should be_an Array
    # end

    # it "stores headers on the Merchant class" do
    #   SalesEngine::Merchant.csv_headers.should be_an Array
    # end
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
        merchant.total_revenue.should == BigDecimal("513387.14")
      end
    end
  end

  context "business intelligence methods" do
    describe ".most_revenue" do
      it "returns an array of Merchants" do
        SalesEngine::Merchant.most_revenue(1).first.should be_a(SalesEngine::Merchant)
      end
      it "returns merchants sorted by descending revenue" do
        merch_a = SalesEngine::Merchant.find_by_id(89)
        merch_b = SalesEngine::Merchant.find_by_id(74)
        merch_c = SalesEngine::Merchant.find_by_id(10)
        SalesEngine::Merchant.most_revenue(3).should == [ merch_a, merch_b, merch_c ]
      end
    end
    describe ".most_items" do
      it "returns an array of Merchants" do
        SalesEngine::Merchant.most_items(1).first.should be_a(SalesEngine::Merchant)
      end
      it "returns merchants sorted by descending items sold" do
        merch_a = SalesEngine::Merchant.find_by_id(89)
        merch_b = SalesEngine::Merchant.find_by_id(43)
        merch_c = SalesEngine::Merchant.find_by_id(88)
        SalesEngine::Merchant.most_items(3).should == [ merch_a, merch_b, merch_c ]
      end
    end
    describe ".revenue(date)" do
      it "returns the total revenue across all merchants for one date" do
        SalesEngine::Merchant.revenue(DateTime.parse("2012-02-26 20:56:50 UTC")).should == BigDecimal("2175008.70")
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
    describe "#favorite_customer" do
      it "returns a customer object" do
        SalesEngine::Merchant.find_by_id(1).favorite_customer.should be_a(SalesEngine::Customer)
      end
      it "returns the customer with the most transactions with this merchant" do
        SalesEngine::Merchant.find_by_id(2).favorite_customer.should == SalesEngine::Customer.find_by_id(96)
      end
    end
    describe "#customers_with_pending_invoices" do
      context "when there are no pending invoices" do
        it "returns the empty array" do
          SalesEngine::Merchant.all.first.customers_with_pending_invoices.should == []
        end
      end
      context" when there are pending invoices" do
        it "returns the customers with pending invoices with the merchant" do
          cust_id = SalesEngine::Merchant.all.first.invoices.first.customer_id
          SalesEngine::Customer.find_by_id(cust_id).stub(:has_pending_invoices? => true)
          SalesEngine::Merchant.all.first.customers_with_pending_invoices.should == [SalesEngine::Customer.find_by_id(cust_id)]
        end
      end
    end
  end

  context "extensions" do
    describe ".dates_by_revenue" do
      it  "returns an array of Dates in descending order of revenue" do
        dates = SalesEngine::Merchant.dates_by_revenue

        dates.size.should == 22
      end
    end

    describe ".dates_by_revenue(x)" do
      it  "returns the top x Dates in descending order of revenue" do
        dates = SalesEngine::Merchant.dates_by_revenue(5)

        dates.size.should == 5
        dates[1].should == DateTime.parse("2012-02-17")
        dates.last.should == DateTime.parse("2012-02-11")
      end
    end

    describe ".revenue(range_of_dates)" do
      it "returns the total revenue for all merchants across several dates" do
        date_1 = DateTime.parse("2012-03-14")
        date_2 = DateTime.parse("2012-03-16")
        revenue = SalesEngine::Merchant.revenue(date_1..date_2)

        revenue.should == BigDecimal("6378509.83")
      end
    end

    describe "#revenue(range_of_dates)" do
      it "returns the total revenue for that merchant across several dates" do
        date_1 = DateTime.parse("2012-03-01")
        date_2 = DateTime.parse("2012-03-07")
        merchant = SalesEngine::Merchant.find_by_id(7)
        revenue = merchant.revenue(date_1..date_2)

        revenue.should == BigDecimal("68640.47")
      end
    end
  end

end

#id,name,created_at,updated_at
#1,"Brekke, Haley and Wolff",2012-02-26 20:56:50 UTC,2012-02-26 20:56:50 UTC