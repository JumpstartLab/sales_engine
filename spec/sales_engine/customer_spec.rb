require 'spec_helper'

describe SalesEngine::Customer do

  let(:test_customer){Fabricate(:customer)}

  describe "#invoices" do
    context "returns a collection of invoices" do
      it "contains things which are only invoices" do
        test_customer.invoices.all?{|i| i.is_a? SalesEngine::Invoice}.should == true
      end

      it "contains invoices associated with only this merchant" do
        test_customer.invoices.all? {|i|
          i.customer_id == test_customer.id}.should == true
      end
    end
  end

  describe ".random" do
    it "returns one customer" do
      SalesEngine::Customer.random.should be_a SalesEngine::Customer
    end
  end

  describe "#transactions" do
    it "returns an array of transactions" do
      test_customer.transactions.all?{|i| i.is_a? SalesEngine::Transaction}.should == true
    end

    it "returns transactions associated with this customer" do
      # Go through every transaction returned
        # Check if it is associated with the test_customer id 
    end
  end

  describe "#favorite_merchant" do
    it "returns a merchant" do
      test_customer.favorite_merchant.should be_a SalesEngine::Merchant
    end

    it "returns the merchant with the most transactions/invoices" do
      merchant_1 = Fabricate(:merchant)
      merchant_1_invoices = [ Fabricate(:invoice, :merchant => merchant_1, :customer => test_customer),
      Fabricate(:invoice, :merchant => merchant_1, :customer => test_customer) ]
     
      merchant_2 = Fabricate(:merchant)
      merchant_2_invoices = [ Fabricate(:invoice, :merchant => merchant_2, :customer => test_customer),
      Fabricate(:invoice, :merchant => merchant_2, :customer => test_customer),
      Fabricate(:invoice, :merchant => merchant_2, :customer => test_customer) ]
     
      merchant_3 = Fabricate(:merchant)
      merchant_3_invoices = [ Fabricate(:invoice, :merchant => merchant_3, :customer => test_customer) ]

      test_customer.invoices = [merchant_1_invoices, merchant_2_invoices, merchant_3_invoices].flatten
      test_customer.favorite_merchant.should == merchant_2
    end
  end

  test_customers = [ Fabricate(:customer,
                                :id => "1",
                                :first_name => "John",
                                :last_name => "Doe",
                                :created_at => "3/31",
                                :updated_at => "3/31"),
                      Fabricate(:customer,
                                :id => "2",
                                :first_name => "John",
                                :last_name => "Doe",
                                :created_at => "3/31",
                                :updated_at => "3/31"),
                      Fabricate(:customer,
                                :id => "3",
                                :first_name => "John",
                                :last_name => "Doe",
                                :created_at => "3/31",
                                :updated_at => "3/31") ]

  describe ".find_by_id()" do
    it "returns one customer" do
      SalesEngine::Database.instance.stub(:customers).and_return(test_customers)
      SalesEngine::Customer.find_by_id("1").should be_a SalesEngine::Customer
    end

    it "is associated with the id passed in" do
      SalesEngine::Database.instance.stub(:customers).and_return(test_customers)
      result = SalesEngine::Customer.find_by_id("1")
      result.id.should == "1"
    end
  end

  describe ".find_all_by_id()" do
    it "returns an array of transactions" do
      SalesEngine::Database.instance.stub(:customers).and_return(test_customers)
      SalesEngine::Customer.find_all_by_id("2").all?{|i| i.is_a? SalesEngine::Customer}.should == true
    end

    it "contains transactions related to the id passed in" do
      SalesEngine::Database.instance.stub(:customers).and_return(test_customers)
      result = SalesEngine::Customer.find_all_by_id("1")
      result.sample.id.should == "1"
    end
  end

  describe ".find_by_first_name()" do
    it "returns one customer" do
      SalesEngine::Database.instance.stub(:customers).and_return(test_customers)
      SalesEngine::Customer.find_by_first_name("John").should be_a SalesEngine::Customer
    end

    it "is associated with the id passed in" do
      SalesEngine::Database.instance.stub(:customers).and_return(test_customers)
      result = SalesEngine::Customer.find_by_first_name("John")
      result.first_name.should == "John"
    end
  end

  describe ".find_all_by_first_name()" do
    it "returns an array of transactions" do
      SalesEngine::Database.instance.stub(:customers).and_return(test_customers)
      SalesEngine::Customer.find_all_by_first_name("John").all?{|i| i.is_a? SalesEngine::Customer}.should == true
    end

    it "contains transactions related to the first_name passed in" do
      SalesEngine::Database.instance.stub(:customers).and_return(test_customers)
      result = SalesEngine::Customer.find_all_by_first_name("John")
      result.sample.first_name.should == "John"
    end
  end

  describe ".find_by_last_name()" do
    it "returns one customer" do
      SalesEngine::Database.instance.stub(:customers).and_return(test_customers)
      SalesEngine::Customer.find_by_last_name("Doe").should be_a SalesEngine::Customer
    end

    it "is associated with the id passed in" do
      SalesEngine::Database.instance.stub(:customers).and_return(test_customers)
      result = SalesEngine::Customer.find_by_last_name("Doe")
      result.last_name.should == "Doe"
    end
  end

  describe ".find_all_by_last_name()" do
    it "returns an array of transactions" do
      SalesEngine::Database.instance.stub(:customers).and_return(test_customers)
      SalesEngine::Customer.find_all_by_last_name("Doe").all?{|i| i.is_a? SalesEngine::Customer}.should == true
    end

    it "contains transactions related to the id passed in" do
      SalesEngine::Database.instance.stub(:customers).and_return(test_customers)
      result = SalesEngine::Customer.find_all_by_last_name("Doe")
      result.sample.last_name.should == "Doe"
    end
  end

  describe ".find_by_created_at()" do
    it "returns one customer" do
      SalesEngine::Database.instance.stub(:customers).and_return(test_customers)
      SalesEngine::Customer.find_by_created_at("3/31").should be_a SalesEngine::Customer
    end

    it "is associated with the id passed in" do
      SalesEngine::Database.instance.stub(:customers).and_return(test_customers)
      result = SalesEngine::Customer.find_by_created_at("3/31")
      result.created_at.should == "3/31"
    end
  end

  describe ".find_all_by_created_at()" do
    it "returns an array of transactions" do
      SalesEngine::Database.instance.stub(:customers).and_return(test_customers)
      SalesEngine::Customer.find_all_by_created_at("3/31").all?{|i| i.is_a? SalesEngine::Customer}.should == true
    end

    it "contains transactions related to the date passed in" do
      SalesEngine::Database.instance.stub(:customers).and_return(test_customers)
      result = SalesEngine::Customer.find_all_by_created_at("3/31")
      result.sample.created_at.should == "3/31"
    end
  end

  describe ".find_by_updated_at()" do
    it "returns one customer" do
      SalesEngine::Database.instance.stub(:customers).and_return(test_customers)
      SalesEngine::Customer.find_by_updated_at("3/31").should be_a SalesEngine::Customer
    end

    it "is associated with the date passed in" do
      SalesEngine::Database.instance.stub(:customers).and_return(test_customers)
      result = SalesEngine::Customer.find_by_updated_at("3/31")
      result.updated_at.should == "3/31"
    end
  end

  describe ".find_all_by_updated_at()" do
    it "returns an array of transactions" do
      SalesEngine::Database.instance.stub(:customers).and_return(test_customers)
      SalesEngine::Customer.find_all_by_updated_at("3/31").all?{|i| i.is_a? SalesEngine::Customer}.should == true
    end

    it "contains transactions related to the date passed in" do
      SalesEngine::Database.instance.stub(:customers).and_return(test_customers)
      result = SalesEngine::Customer.find_all_by_updated_at("3/31")
      result.sample.updated_at.should == "3/31"
    end
  end

end
