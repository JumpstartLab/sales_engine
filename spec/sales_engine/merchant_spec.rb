require 'spec_helper'

describe SalesEngine::Merchant do
  param = {:id => 1, 
           :name => "Brekke, Haley and Wolff", 
           :created_at => "2012-02-26 20:56:50 UTC", 
           :updated_at => "2012-02-26 20:56:50 UTC"}

  let(:merchant) {SalesEngine::Merchant.new(param)}

  describe 'initialize' do
    context "when instantiating a new merchant" do
      it 'receives a hash as a param' do
        param.should be_a(Hash)
      end
      [:id, :name, :created_at, :updated_at].each do |method|
        it "sets the merchant's attribute #{method} with the method #{method}" do
          merchant.send(method).should_not be_nil
        end
      end
    end
  end

  let(:merchants) {SalesEngine::Database.instance.merchants}
  
  describe '.collection' do
    it 'creates an array' do
      merchants.should be_a(Array)
    end
    it 'contains instances of the merchant class' do
      merchants.first.class.should == merchant.class
    end
    it 'is not empty' do
      merchants.should_not be_empty
    end
  end

  describe '.database' do
    it 'proxies to Database' do
      SalesEngine::Database.should_receive(:instance)
      SalesEngine::Merchant.database
    end
  end

  describe '#database' do
    it 'proxies to Database' do
      SalesEngine::Database.should_receive(:instance)
      merchant.database
    end
  end

  describe '#database=' do
    it 'proxies to Database' do
      SalesEngine::Database.should_receive(:instance)
      merchant.database
    end
  end

  describe '#invoices' do
    let(:dbinvoices) {SalesEngine::Database.instance.invoices}
    it "returns an array" do
      merchant.invoices.should be_a(Array)
    end
    it 'returns instances of the invoice class' do
      merchant = merchants[0]
      result = merchant.invoices[0]
      result.class.should == dbinvoices[0].class
    end
    it 'returns an empty array if no results found' do
      merchant.invoices.should == []
    end
  end
  
  describe '#items' do
    let(:dbitems) {SalesEngine::Database.instance.items}
    it "returns an array" do
      merchant.items.should be_a(Array)
    end
    it 'returns instances of the item class' do
      merchant = merchants[0]
      result = merchant.items[0]
      result.class.should == dbitems[0].class
    end
    it 'returns an empty array if no results found' do
      merchant.items.should == []
    end
  end

  describe '.most_items(x)' do
    pending
  end

  describe '.revenue(date)' do
    it 'sums up the revenue' do
      pending
    end
  end
  
  #################
  #################
  #################

  describe '#revenue' do
    it 'calculates revenue for each matched invoice item' do
      inv_items = merchants[0].invoice_items
      sum = inv_items.inject(0){ |acc,num| (num.quantity.to_i * num.unit_price.to_i) + acc }
      merchants[0].revenue.should == sum
    end
  end

  describe '.most_revenue' do
    context "when given a number as an argument" do
      it 'returns an array' do
        result = SalesEngine::Merchant.most_revenue(5)
        result.count.should == 5
      end
      it 'returns merchants' do
        result = SalesEngine::Merchant.most_revenue(5)
        result.first.class.should == SalesEngine::Item
      end
    end

    context "when no argument is given" do
      it "returns a single item" do
        result = SalesEngine::Merchant.most_revenue
        result.should be_instance_of(SalesEngine::Merchant)
      end
    end
  end

  describe '.sort_by_revenue' do
    pending
    # it 'returns a sorted collection' do
    #   raise (result = SalesEngine::Item.sort_by_revenue).inspect
    #   # result.first > result.last.should be > result.last
    # end
  end  

  #################
  #################
  #################

  describe '#revenue(date)' do
    pending
  end
  
  describe '#favorite_customer' do
    pending
  end
  
  describe '#customers_with_pending_invoices' do
    pending
  end

end