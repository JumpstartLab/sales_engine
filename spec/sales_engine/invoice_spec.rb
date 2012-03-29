require 'spec_helper.rb'

describe SalesEngine::Invoice do

  describe "find_by_" do
    attributes = [:id, :customer_id, :merchant_id, :status, 
                    :created_at, :updated_at]
    attributes.each do |attribute|
      method_name = "find_by_#{attribute}".to_sym

      it "responds to #{method_name}" do
        SalesEngine::Invoice.should respond_to(method_name)
      end
    end
  end

  describe "find_all_by_" do
    attributes = [:id, :customer_id, :merchant_id, :status, 
                    :created_at, :updated_at]
    attributes.each do |attribute|
      method_name = "find_all_by_#{attribute}".to_sym

      it "responds to #{method_name}" do
        SalesEngine::Invoice.should respond_to(method_name)
      end
    end
  end

  describe "#transactions" do
    let(:invoice) { SalesEngine::Invoice.random }
    it "responds to the method" do 
      invoice.should respond_to("transactions".to_sym)
    end 
    it "returns transactions with the same invoice id as the sample" do 
      transactions = invoice.transactions 
      transactions.collect do |transaction| 
        transaction.invoice_id.should == invoice.id
      end
    end 
  end

  describe "#invoice_items" do
    let (:invoice) { SalesEngine::Invoice.random }

    it "responds to the method" do 
      invoice.should respond_to("invoice_items".to_sym)
    end

    it "returns a collection of associated invoice_item objects" do 
      invoice_items = invoice.invoice_items
      invoice_items.collect do |invoice_item| 
        invoice_item.invoice_id.should == invoice.id
      end
    end
  end

  describe "#items" do
    let (:invoice) { SalesEngine::Invoice.random }

    it "responds to the method" do 
      invoice.should respond_to("items".to_sym)
    end

    it "returns a collection of associated items by way of invoice_item objects" do
      items = invoice.items 
      items.count.should_not == 0
    end 
  end

  describe "#customer" do
    let (:invoice) { SalesEngine::Invoice.random }
    it "responds to the method" do 
      invoice.should respond_to("customer".to_sym)
    end
    it "returns an instance of customer associated with this object" do 
      customer = invoice.customer 
      invoice.customer_id.should == customer.id
    end
  end

  describe ".create" do
    let(:customer) {SalesEngine::Customer.random}
    let(:merchant) {SalesEngine::Merchant.random}
    let(:items) do
      (1..3).map {SalesEngine::Item.random}
    end

    it "responds to the method" do
      SalesEngine::Invoice.should respond_to("create".to_sym)
    end

    it "creates a new invoice" do
      invoice = SalesEngine::Invoice.create(:customer => customer, 
                                            :merchant => merchant,
                                            :items => items)

      items.map(&:name).each do |name|
          invoice.items.map(&:name).should include(name)
      end

      invoice.customer.id.should == customer.id
    end
  end

  describe "#charge" do
    # it "responds to the method" do 
    #   SalesEngine::Invoice.should respond_to("charge".to_sym)
    # end

    it "creates a new instance of transaction" do 
      invoice = SalesEngine::Invoice.find_by_id(99)
      t_count = invoice.transactions.count

      invoice.charge(credit_card_number: '1111222233334444',  credit_card_expiration_date: "10/14", result: "success")
      
      invoice = SalesEngine::Invoice.find_by_id(invoice.id)
      invoice.transactions.count.should == t_count + 1
    end
  end  

end