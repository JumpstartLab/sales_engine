require 'spec_helper.rb'

describe SalesEngine::Item do
 
    let(:test_customer) {SalesEngine::Customer.random}
    let(:test_merchant) {SalesEngine::Merchant.random}
    let(:test_invoice) {SalesEngine::Invoice.random}
    let(:test_item) {SalesEngine::Item.random}
    let(:test_transaction) {SalesEngine::Transaction.random}
    let(:test_invoice_item) {SalesEngine::InvoiceItem.random}

  describe 'test accessors' do
    SalesEngine::Item::ATTRIBUTES.each do |attribute|
      context "responds to attr_accessors" do
        it "generates the reader" do
          test_item.should be_respond_to("#{attribute}")
        end
        it "generates the writer" do
          test_item.should be_respond_to("#{attribute}=")
        end
      end
    end
  end

  describe "#invoice_items" do
    it "returns an array of InvoiceItem objects" do
      test_item.invoice_items.each do |invoice_item|
        invoice_item.should be_is_a(SalesEngine::InvoiceItem)
      end
    end
  end

  describe "#merchant" do
    it "returns an instace of Merchant" do
      merchant = test_item.merchant
      merchant.should be_is_a(SalesEngine::Merchant)
    end
  end

  describe "#calc_revenue" do
    it "returns a Big Decimal" do
      test_item.calc_revenue.should be_is_a(BigDecimal)
    end
  end

  describe ".most_revenue" do
    it "returns an array of Item objects" do
      top_items = SalesEngine::Item.most_revenue(6)
      top_items.each do |item|
        item.should be_is_a(SalesEngine::Item)
      end
    end
    it "orders the items by revenue" do
      top_items = SalesEngine::Item.most_revenue(6)
      top_items.each_slice(2) do |a,b|
        if b
          a.revenue.should >= b.revenue
        end
      end
    end
  end

  describe "#best_day" do
    it "returns a date" do
      test_item.best_day.should be_is_a(Date)
    end
  end

  describe ".most_items" do
    it "returns an array of Item Objects" do
      top_items = SalesEngine::Item.most_items(6)
      top_items.each do |item|
        if item
          item.should be_is_a(SalesEngine::Item)
        end
      end
    end

    it "orders the items by quantity sold" do
      top_items = SalesEngine::Item.most_items(6)
      top_items.each_slice(2) do |a,b|
        if b
          a.items_sold.should >= b.items_sold
        end
      end
    end
  end
end





