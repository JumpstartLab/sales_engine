require 'spec_helper'

describe SalesEngine::Merchant do

  let(:test_merchant) { Fabricate(:merchant) }
  
  describe "#items" do 
    context "returns a collection of items" do

      it "contains things which are only items" do
        test_merchant.items.all?{|i| i.is_a? SalesEngine::Item}.should == true
      end

      it "contains items associated with only this merchant" do
        test_merchant.items.all? {|i| 
          i.merchant_id == test_merchant.id}.should == true
      end
    end
  end

  describe ".random" do 
    it "returns one merchant from all the merchants" do
      tester = SalesEngine::Merchant.random 
      tester.is_a?(SalesEngine::Merchant).should == true
    end
  end

  describe "#invoices" do
    context "returns a collection of invoices" do

      it "contains things which are only invoices" do
        test_merchant.invoices.all?{|i| i.is_a? SalesEngine::Invoice}.should == true
      end

      it "contains invoices associated only with this merchant" do
        test_merchant.invoices.all?{|i|
          i.merchant_id == test_merchant.id}.should == true
      end
    end
  end

  describe "#revenue" do
    context "returns total revenue for this merchant" do
      it "returns a BigDecimal" do
        test_merchant.revenue.is_a?(BigDecimal).should == true
      end

      it "returns a BigDecimal to two decimal points" do
        # test_merchant.should_receive(:invoices)
        # test_merchant.revenue
      end

      it "gets the invoice items for each invoice" do
        # test_merchant.invoices.should_receive(:invoice_items)
        # test_merchant.revenue
      end

      it "correctly tallies each item on each invoice items" do
        # call the revenue method on test_merchant
        # it should equal what we put in the stub
      end
    end
  end

  describe "#favorite_customer" do

    it "returns a customer" do
      test_merchant.favorite_customer.should be_a (SalesEngine::Customer)
    end

    it "returns the customer with the most transactions/invoices" do
      customer_1 = Fabricate(:customer)
      customer_1_invoices = [ Fabricate(:invoice, :customer => customer_1, :merchant => test_merchant),
        Fabricate(:invoice, :customer => customer_1, :merchant => test_merchant)]

      customer_2 = Fabricate(:customer)
      customer_2_invoices = [ Fabricate(:invoice, :customer => customer_2, :merchant => test_merchant),
        Fabricate(:invoice, :customer => customer_2, :merchant => test_merchant),
        Fabricate(:invoice, :customer => customer_2, :merchant => test_merchant)]

      customer_3 = Fabricate(:customer)
      customer_3_invoices = [ Fabricate(:invoice, :customer => customer_3, :merchant => test_merchant)]

      test_merchant.invoices = [customer_1_invoices, customer_2_invoices, customer_3_invoices].flatten

      test_merchant.favorite_customer.should == customer_2
    end
  end

  describe "#customers" do
    it "returns the set of associated customers" do
      customer_1 = Fabricate(:customer)
      customer_1_invoices = [ Fabricate(:invoice, :customer => customer_1, :merchant => test_merchant),
        Fabricate(:invoice, :customer => customer_1, :merchant => test_merchant)]

      customer_2 = Fabricate(:customer)
      customer_2_invoices = [ Fabricate(:invoice, :customer => customer_2, :merchant => test_merchant),
        Fabricate(:invoice, :customer => customer_2, :merchant => test_merchant),
        Fabricate(:invoice, :customer => customer_2, :merchant => test_merchant)]

      test_merchant.invoices = [customer_1_invoices, customer_2_invoices].flatten

      test_merchant.customers.should include(customer_1)
      test_merchant.customers.should include(customer_2)
    end
  end

  test_merchants = [Fabricate(:merchant,
                               :id => "1",
                               :name => "Merchant Name",
                               :created_at => "3/31",
                               :updated_at => "3/31"),
                    Fabricate(:merchant,
                               :id => "2",
                               :name => "Merchant Name",
                               :created_at => "3/31",
                               :updated_at => "3/31"),
                    Fabricate(:merchant,
                               :id => "3",
                               :name => "Merchant Name",
                               :created_at => "3/31",
                               :updated_at => "3/31") ]

  describe ".find_by_id()" do

    it "returns one merchant" do
      SalesEngine::Database.instance.stub(:merchants).and_return(test_merchants)
      SalesEngine::Merchant.find_by_id("1").should be_a SalesEngine::Merchant
    end

    it "is associated with the id passed in" do
      SalesEngine::Database.instance.stub(:merchants).and_return(test_merchants)
      result = SalesEngine::Merchant.find_by_id("1")
      result.id.should == "1"
    end
  end

  describe ".find_by_name()" do
    it "returns one merchant" do
      SalesEngine::Database.instance.stub(:merchants).and_return(test_merchants)
      SalesEngine::Merchant.find_by_name("Merchant Name").should be_a SalesEngine::Merchant
    end

    it "is associated with the name passed in" do
      SalesEngine::Database.instance.stub(:merchants).and_return(test_merchants)
      result = SalesEngine::Merchant.find_by_name("Merchant Name")
      result.name.should == "Merchant Name"
    end
  end

  describe ".find_by_created_at()" do
    it "returns one merchant" do
      SalesEngine::Database.instance.stub(:merchants).and_return(test_merchants)
      SalesEngine::Merchant.find_by_created_at("3/31").should be_a SalesEngine::Merchant
    end

    it "is associated with the created_at passed in" do
      SalesEngine::Database.instance.stub(:merchants).and_return(test_merchants)
      result = SalesEngine::Merchant.find_by_created_at("3/31")
      result.created_at.should == "3/31"
    end
  end

  describe ".find_by_updated_at()" do
    it "returns one merchant" do
      SalesEngine::Database.instance.stub(:merchants).and_return(test_merchants)
      SalesEngine::Merchant.find_by_updated_at("3/31").should be_a SalesEngine::Merchant
    end

    it "is associated with the updated_at passed in" do
      SalesEngine::Database.instance.stub(:merchants).and_return(test_merchants)
      result = SalesEngine::Merchant.find_by_updated_at("3/31")
      result.updated_at.should == "3/31"
    end
  end

  describe ".find_all_by_id()" do
    it "returns an array of merchants" do
      SalesEngine::Database.instance.stub(:merchants).and_return(test_merchants)
      SalesEngine::Merchant.find_all_by_id("1").all?{|i| i.is_a? SalesEngine::Merchant}.should == true
    end

    it "contains merchants related to the id given" do
      SalesEngine::Database.instance.stub(:merchants).and_return(test_merchants)
      results = SalesEngine::Merchant.find_all_by_id("1")
      results.sample.id.should == "1"
    end
  end

  describe ".find_all_by_name()" do
    it "returns an array of merchants" do
      SalesEngine::Database.instance.stub(:merchants).and_return(test_merchants)
      SalesEngine::Merchant.find_all_by_name("Merchant Name").all?{|i| i.is_a? SalesEngine::Merchant}.should == true
    end

    it "contains merchants related to the name given" do
      SalesEngine::Database.instance.stub(:merchants).and_return(test_merchants)
      results = SalesEngine::Merchant.find_all_by_name("Merchant Name")
      results.sample.name.should == "Merchant Name"
    end
  end

  describe ".find_all_by_created_at()" do
    it "returns an array of merchants" do
      SalesEngine::Database.instance.stub(:merchants).and_return(test_merchants)
      SalesEngine::Merchant.find_all_by_created_at("3/31").all?{|i| i.is_a? SalesEngine::Merchant}.should == true
    end


    it "contains merchants related to the created_at given" do
      SalesEngine::Database.instance.stub(:merchants).and_return(test_merchants)
      results = SalesEngine::Merchant.find_all_by_created_at("3/31")
      results.sample.created_at.should == "3/31"
    end
  end

  describe ".find_all_by_updated_at()" do
    it "returns an array of merchants" do
      SalesEngine::Database.instance.stub(:merchants).and_return(test_merchants)
      SalesEngine::Merchant.find_all_by_updated_at("3/31").all?{|i| i.is_a? SalesEngine::Merchant}.should == true
    end


    it "contains merchants related to the updated_at given" do
      SalesEngine::Database.instance.stub(:merchants).and_return(test_merchants)
      results = SalesEngine::Merchant.find_all_by_updated_at("3/31")
      results.sample.updated_at.should == "3/31"
    end
  end

end


