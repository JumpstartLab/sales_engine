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
    end

    it "returns an instance of Merchant" do
      result = SalesEngine::Merchant.random
      result.class.should == SalesEngine::Merchant
    end
  end

  describe "#items" do
    let(:merchant) { SalesEngine::Merchant.random }
    it "responds to the method" do
      merchant.should respond_to("items".to_sym)
    end

    it "returns items with the same merchant id as the example" do
      items = merchant.items
      items.collect do |item|
        item.merchant_id.should == merchant.id
      end
    end
  end

  describe "#invoices" do 
    let(:merchant) { SalesEngine::Merchant.random }
    it "responds to the method" do
      merchant.should respond_to("invoices".to_sym)
    end

    it "returns invoices with the same merchant_id as the example" do
      invoices = merchant.invoices
      invoices.collect do |invoice|
        invoice.merchant_id.should == merchant.id
      end
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
    let(:merchant) { SalesEngine::Merchant.random }

    it "responds to the method" do
      merchant.should respond_to("revenue".to_sym)
    end

    it "returns as BigDecimal" do
      merchant.revenue.class.should == BigDecimal
    end

  end 

  describe "#revenue(date=nil)" do
    it "returns the total revenue for the merchant for a specific date"
  end

  describe "#favorite_customer" do
    let(:merchant) { SalesEngine::Merchant.random }

    it "responds to the method" do
      merchant.should respond_to("favorite_customer".to_sym)
    end

    it "returns the Customer who has conducted the most transactions with "
  end

  describe "#customers_with_pending_invoices" do
    it "returns a collection of Customer instances which have pending(unpaid) invoices"
  end
 end 