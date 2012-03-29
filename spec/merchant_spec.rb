require 'spec_helper'

describe SalesEngine::Merchant do
  let(:merchant) { Fabricate(:merchant) }

  before(:all) { SalesEngine.startup('data/evaluation') }

  it 'creates a merchant with valid attributes' do
    merchant.nil?.should be_false
  end

  it "doesn't create merchant without arguments" do
    expect do
      SalesEngine::Merchant.new() 
    end.to raise_error(ArgumentError)
  end

  context "name attribute" do
    it "has a name" do
      merchant.name.should_not be_nil
    end

    it "doesn't create a merchant with a nil name" do
      expect do
        SalesEngine::Merchant.new(:id => 1, :name => nil) 
      end.to raise_error(ArgumentError)
    end

    it "doesn't create a merchant with a blank name" do
      expect do
        SalesEngine::Merchant.new(:id => 1, :name => "") 
      end.to raise_error(ArgumentError)
    end
  end

  context "updated_at" do
    it "is updated when a valid_sample's name changes" do
      old_updated_at = merchant.updated_at
      merchant.name = 'Jackie Chan'
      merchant.updated_at.should > old_updated_at
    end
  end

  context "created_at" do
    it "is not updated when a merchant's name changes" do
      old_created_at = merchant.created_at
      merchant.name = 'Jackie Chan'
      merchant.created_at.should == old_created_at
    end
  end

  # Harness Tests
  
  context "Searching" do
    describe ".random" do
      it "usually returns different things on subsequent calls" do
        merchant_one = SalesEngine::Merchant.random
        merchant_two = SalesEngine::Merchant.random

        10.times do
          break if merchant_one.id != merchant_two.id
          merchant_two = SalesEngine::Merchant.random
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
        invoice = merchant.invoices.find {|i| i.customer.last_name == 'Block' }
        invoice.status.should == "shipped"
      end
    end
  end

  context "Business Intelligence" do
    describe ".revenue" do
      it "returns all revenue for a given date" do
        pending
        date = Date.parse "Tue, 20 Mar 2012"

        revenue = SalesEngine::Merchant.revenue(date)
        revenue.should == BigDecimal.new("2549722.91")
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
        most = SalesEngine::Merchant.most_items(5)
        most.first.name.should == "Kassulke, O'Hara and Quitzon"
        most.last.name.should  == "Daugherty Group"
      end
    end

    describe "#revenue" do
      context "without a date" do
        let(:merchant) { SalesEngine::Merchant.find_by_name "Dicki-Bednar" }

        it "reports all revenue" do
          merchant.revenue.should == BigDecimal.new("1148393.74")
        end
      end
      # context "given a date" do
        # let(:merchant) { SalesEngine::Merchant.find_by_name "Willms and Sons" }

        # it "restricts to that date" do
          # date = Date.parse "Fri, 09 Mar 2012"

          # merchant.revenue(date).should == BigDecimal.new("8373.29")
        # end
      # end
    end

    describe "#favorite_customer" do
      let(:merchant) { SalesEngine::Merchant.find_by_name "Terry-Moore" }
      let(:customer_names) do
        [["Jayme", "Hammes"], ["Elmer", "Konopelski"], ["Eleanora", "Kling"],
         ["Friedrich", "Rowe"], ["Orion", "Hills"], ["Lambert", "Abernathy"]]
      end

      it "returns the customer with the most transactions" do
        customer = merchant.favorite_customer
        customer_names.any? do |first_name, last_name|
          customer.first_name == first_name
          customer.last_name  == last_name
        end.should be_true
      end
    end

    # describe "#customers_with_pending_invoices" do
      # let(:merchant) { SalesEngine::Merchant.find_by_name "Parisian Group" }

      # it "returns the total number of customers with pending invoices" do
        # customers = merchant.customers_with_pending_invoices
        # customers.count.should == 4
        # customers.any? do |customer|
          # customer.last_name == "Ledner"
        # end.should be_true
      # end
    # end
  end
end
