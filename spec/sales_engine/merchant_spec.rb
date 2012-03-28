require 'spec_helper'

describe SalesEngine::Merchant do
  param = {:id => 1, 
           :name => "Brekke, Haley and Wolff", 
           :created_at => "2012-02-26 20:56:50 UTC", 
           :updated_at => "2012-02-26 20:56:50 UTC"}
  let(:merchant) {SalesEngine::Merchant.new(param)}
  #let(:merchant) { Fabricate(:merchant) }
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

  let(:collection) {SalesEngine::Database.instance.merchants}
  
  describe '#invoices' do
    let(:dbinvoices) {SalesEngine::Database.instance.invoices}
    it "returns an array" do
      merchant.invoices.should be_a(Array)
    end
    it 'returns instances of the invoice class' do
      merchant = collection[0]
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
      merchant = collection[0]
      result = merchant.items[0]
      result.class.should == dbitems[0].class
    end
    it 'returns an empty array if no results found' do
      merchant.items.should == []
    end
  end

  describe '.most_revenue(x)'  do
    pending
  end

  describe '.most_items(x)' do
    pending
  end
  
  describe '.revenue(date)' do
    pending
  end
  
  describe '#revenue' do
    pending
  end
  
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