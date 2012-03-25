require 'spec_helper.rb'

describe SalesEngine::Merchant do
  
  describe "find_by_" do
    attributes = [:id, :name, :created_at, :updated_at]
    attributes.each do |attribute|
      method_name = "find_by_#{attribute}".to_sym

      it "responds to #{method_name}" do
        SalesEngine::Merchant.should respond_to(method_name)
      end
    end
  end

  describe "find_all_by_" do
    attributes = [:id, :name, :created_at, :updated_at]
    attributes.each do |attribute|
      method_name = "find_all_by_#{attribute}".to_sym

      it "responds to #{method_name}" do
        SalesEngine::Merchant.should respond_to(method_name)
      end
    end
  end

  describe ".random" do
    it "responds to the method call" do
      SalesEngine::Merchant.should respond_to("random".to_sym)
      # result = Merchant.random  
      # result.class.should == Merchant.class 
    end

    it "returns an instance of Merchant" do
      result = SalesEngine::Merchant.random
      result.class.should == SalesEngine::Merchant
    end
  end

  describe "#items" do
    it "returns a collection of item instances associated with merchant" do 
      result = Merchant.new
      result.items.class.should == item.class 
    end
  end

  describe "#invoices" do 
    it "returns a collection of invoices associated with merchant" do 
      result = Merchant.new
      result.invoces.class.should == invoice.class
    end
  end 

  describe ".most_revenue(num_of_merchants)" do
    it "returns the top num_of_merchants instances ranked by total revenue" do 
      num_of_merchants = 3 
      result = Merchant.most_revenue(num_of_merchants)
      result.length.should == num_of_merchants
    end 
  end

  describe ".most_items(num_of_merchants)" do
    it "returns top num_of_merchants instances ranked by total items sold" do
      num_of_merchants = 3
      result = Merchant.most_items(num_of_merchants)
      result.length.should == num_of_merchants
    end
  end

  describe "#revenue" do 
    it "returns the total revenue for that merchant across all transactions" do
    end
  end 

  describe "#revenue(date=nil)" do
    it "returns the total revenue for the merchant for a specific date" do
    end
  end

  describe "#favorite_customer" do
    it "returns the Customer who has conducted the most transactions with " do 
    end
  end

  describe "#customers_with_pending_invoices" do
    it "returns a collection of Customer instances which have pending(unpaid) invoices" do 
    end 
  end
 end 