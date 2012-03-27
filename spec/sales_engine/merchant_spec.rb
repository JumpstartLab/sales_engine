require 'spec_helper.rb'

describe SalesEngine::Merchant do

  let(:test_customer) {SalesEngine::Customer.random}
  let(:test_merchant) {SalesEngine::Merchant.random}
  let(:test_invoice) {SalesEngine::Invoice.random}
  let(:test_item) {SalesEngine::Item.random}
  let(:test_transaction) {SalesEngine::Transaction.random}
  let(:test_invoice_item) {SalesEngine::InvoiceItem.random}

  describe 'find_by_#{attribute}(attribute) methods' do
    SalesEngine::Merchant::ATTRIBUTES.each do |attribute|
      context ".find_by_#{attribute}" do
        it "should have generated the class method" do
          SalesEngine::Merchant.should be_respond_to("find_by_#{attribute}")
        end
      end
    end
  end

  describe 'test accessors' do
    SalesEngine::Merchant::ATTRIBUTES.each do |attribute|
      context "responds to attr_accessors" do
        it "generates the reader" do
          test_merchant.should be_respond_to("#{attribute}")
        end
        it "generates the writer" do
          test_merchant.should be_respond_to("#{attribute}=")
        end
      end
    end
  end

  context "#items" do
    it "returns an array of items" do
      items = test_merchant.items
      items.should be_is_a(Array)
    end

    it "should return and array of Items" do
      items = test_merchant.items
      items.each do |item|
        item.should be_is_a(SalesEngine::Item)
      end
    end
  end

  context "#invoices" do
    it "returns an array" do
      invoices = test_merchant.invoices
      invoices.should be_is_a(Array)
    end

    it "returns an array of Invoices" do
      invoices = test_merchant.invoices
      invoices.each do |invoice|
        invoice.should be_is_a(SalesEngine::Invoice)
      end
    end
  end

  context "#revenue" do
    it "returns a valid total revenue without argument" do
      revenue = test_merchant.revenue
      revenue.should be_is_a(BigDecimal)
    end

    it "returns a valid number for a given date" do
      test_date = Date.parse("2012-02-08 01:56:56 UTC")
      revenue = test_merchant.revenue(test_date)
      revenue.should be_is_a(BigDecimal)
    end
  end

  context ".most_revenue(x)" do
    x = 10
    it "returns an Array of size x" do
      top_merchants = SalesEngine::Merchant.most_revenue(x)
      top_merchants.count.should == x
    end

    it "orders merchants by revenue" do
      top_merchants = SalesEngine::Merchant.most_revenue(x)
      top_merchants.each_slice(2) do |a,b|
        if b
          a.revenue.should >= b.revenue
        end
      end
    end
  end

  context ".most_items(x)" do
    x = 10
    it "returns an array of size x" do 
      top_merchants = SalesEngine::Merchant.most_items(x)
      top_merchants.count.should == x
    end

    it "orders merchants by items" do
      top_merchants = SalesEngine::Merchant.most_items(x)
      top_merchants.each_slice(2) do |a,b|
        if b
          a.items_sold.should >= b.items_sold
        end
      end
    end
  end

  context "#customers_with_pending_invoices" do
    it "returns an array of customers" do
      customers = test_merchant.customers_with_pending_invoices
      customers.should be_is_a(Array)
      if customers.any?
        customers.each do |customer|
          customer.should be_is_a(Customer)
        end
      end
    end 
  end

  context "#favorite customer" do
    it "returns a customer object" do
      fav_customer = test_merchant.favorite_customer
      if fav_customer
        fav_customer.should be_is_a(SalesEngine::Customer)
      end
    end
  end
end

