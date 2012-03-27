require 'spec_helper'

describe Merchant do
  context "Searching" do
    describe ".random" do
      it "usually returns different things on subsequent calls" do
        merchant_one = Merchant.random
        10.times do
          merchant_two = Merchant.random
          break if merchant_one != merchant_two
        end

        merchant_one.should_not == merchant_two
      end
    end

    describe ".find_by_name" do
      merchant = Merchant.find_by_name "Satterfield and Sons"
      merchant.should_not be_nil
    end

    describe ".find_by_all_name" do
      merchants = Merchant.find_all_by_name "Senger Group"
      merchants.should have(2).merchants
    end
  end

  context "Relationships" do
    let(:merchant) { Merchant.find_by_name "Hyatt and Sons" }

    describe "#items" do
      it "has 14 of them" do
        merchant.items.should have(14).items
      end

      it "includes an 'Item Optio Libero'" do
        item = merchant.items.find {|i| i.name == 'Item Optio Libero' }
        item.should_not be_nil
      end
    end

    describe "#invoices" do
      it "has 52 of them" do
        merchant.invoices.should have(52).invoices
      end

      it "has a shipped invoice for Schmeler" do
        invoices = merchant.invoices.find {|i| i.name = 'Schmeler' }
        item.status.should == "shipped"
      end
    end
  end

  context "Business Intelligence" do

    describe ".revenue" do
      it "returns all revenue for a given date" do
        date = Date.parse "Tue, 20 Mar 2012"

        Merchant.revenue(date).to_f.should be_within(0.001).of(6082388505.0)
      end
    end

    describe ".most_revenue" do
      it "returns the top n revenue-earners" do
        most = Merchant.most_revenue(3)
        most.first.name.should == "Gutkowski, Bechtelar and Predovic"
        most.last.name.should  == "Greenfelder, King and Hoeger"
      end
    end

    describe ".most_items" do
      it "returns the top n item-sellers" do
        most = Merchant.most_revenue(4)
        most.first.name.should == "Blanda Inc"
        most.last.name.should  == "Gutmann, Larson and Howe"
      end
    end

    describe "#revenue" do
      context "without a date" do
        let(:merchant) { Merchant.find_by_name "Satterfield and Sons" }

        it "reports correctly" do
          merchant.revenue.to_f.should be_within(0.001).of(47908313.0)
        end
      end
      context "given a date" do
        let(:merchant) { Merchant.find_by_name "Nienow-Quigley" }

        it "restricts to that date" do
          date = Date.parse "Wed, 21 Mar 2012"

          merchant.revenue(date).to_f.should be_within(0.001).of(60265651.0)
        end
      end
    end
  end

  describe "#favorite_customer" do
    let(:merchant) { Merchant.find_by_name "Nienow-Quigley" }

    it "returns the customer with the most transactions" do
      customer = merchant.favorite_customer
      customer.first_name.should == "Bechtelar"
      customer.last_name.should  == "Yazmin"
    end
  end

  describe "#customers_with_pending_invoices" do
    it "returns the total number of customers with pending invoices" do
      pending "No data with pending invoices yet"
      merchant.customers_with_pending_invoices.should == 3
    end
  end
end
