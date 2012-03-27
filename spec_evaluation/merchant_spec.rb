require 'spec_helper'

describe SalesEngine::Merchant do
  context "Searching" do
    describe ".random" do
      it "usually returns different things on subsequent calls" do
        merchant_one = SalesEngine::Merchant.random
        10.times do
          merchant_two = SalesEngine::Merchant.random
          break if merchant_one.id != merchant_two.id
        end

        merchant_one.id.should_not == merchant_two.id
      end
    end

    describe ".find_by_name" do
      it "can find a record" do
        merchant = SalesEngine::Merchant.find_by_name "Marvin Group"
        merchant.should_not be_nil
      end
    end

    describe ".find_by_all_name" do
      it "can find multiple records" do
        merchants = SalesEngine::Merchant.find_all_by_name "Williamson Group"
        merchants.should have(2).merchants
      end
    end
  end

  context "Relationships" do
    let(:merchant) { SalesEngine::Merchant.find_by_name "Kirlin, Jakubowski and Smitham" }

    describe "#items" do
      it "has 33 of them" do
        merchant.items.should have(33).items
      end

      it "includes an 'Item Consequatur Odit'" do
        item = merchant.items.find {|i| i.name == 'Item Consequatur Odit' }
        item.should_not be_nil
      end
    end

    describe "#invoices" do
      it "has 52 of them" do
        merchant.invoices.should have(43).invoices
      end

      it "has a shipped invoice for Block" do
        invoice = merchant.invoices.find {|i| i.customer.last_name = 'Block' }
        invoice.status.should == "shipped"
      end
    end
  end

  context "Business Intelligence" do

    describe ".revenue" do
      it "returns all revenue for a given date" do
        date = Date.parse "Tue, 20 Mar 2012"

        SalesEngine::Merchant.revenue(date).to_f.should be_within(0.001).of(263902466.0)
      end
    end

    describe ".most_revenue" do
      it "returns the top n revenue-earners" do
        most = SalesEngine::Merchant.most_revenue(3)
        most.first.name.should == "Dicki-Bednar"
        most.last.name.should  == "Okuneva, Prohaska and Rolfson"
      end
    end

    describe ".most_items" do
      it "returns the top n item-sellers" do
        most = SalesEngine::Merchant.most_revenue(4)
        most.first.name.should == "Kassulke, O'Hara and Quitzon"
        most.last.name.should  == "Daugherty Group"
      end
    end

    describe "#revenue" do
      context "without a date" do
        let(:merchant) { SalesEngine::Merchant.find_by_name "Dicki-Bednar" }

        it "reports all revenue" do
          merchant.revenue.to_f.should be_within(0.001).of(118422772.0)
        end
      end
      context "given a date" do
        let(:merchant) { SalesEngine::Merchant.find_by_name "Nienow-Quigley" }

        it "restricts to that date" do
          date = Date.parse "Wed, 21 Mar 2012"

          merchant.revenue(date).to_f.should be_within(0.001).of(4521907.0)
        end
      end
    end

    describe "#favorite_customer" do
      let(:merchant) { SalesEngine::Merchant.find_by_name "Terry-Moore" }

      it "returns the customer with the most transactions" do
        customer = merchant.favorite_customer
        customer.first_name.should == "Orion"
        customer.last_name.should  == "Hills"
      end
    end

    describe "#customers_with_pending_invoices" do
      it "returns the total number of customers with pending invoices" do
        customers = merchant.customers_with_pending_invoices
        customers.count.should == 6
        customers.any? do |customer|
          customer.last_name == "Gaylord"
        end.should be_true
      end
    end
  end

end
