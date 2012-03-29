require 'spec_helper.rb'

describe SalesEngine::Customer do

    let(:test_customer) {SalesEngine::Customer.random}
    let(:test_merchant) {SalesEngine::Merchant.random}
    let(:test_invoice) {SalesEngine::Invoice.random}
    let(:test_item) {SalesEngine::Item.random}
    let(:test_transaction) {SalesEngine::Transaction.random}
    let(:test_invoice_item) {SalesEngine::InvoiceItem.random}

  describe '.random' do
    it "returns a Customer object" do
      a = SalesEngine::Customer.random
      a.should be_is_a(SalesEngine::Customer)
    end
  end


  describe 'find_by_#{attribute}(attribute) methods' do
    SalesEngine::Customer::ATTRIBUTES.each do |attribute|
      context ".find_by_#{attribute}" do
        it "should have generated the class method" do
          SalesEngine::Customer.should be_respond_to("find_by_#{attribute}")
        end
      end
    end

    it "returns a customer for find by with correct id" do
      customer = SalesEngine::Customer.find_by_id(test_customer.id.to_i)
      hash = SalesEngine::Database.instance.customer
      customer.should === test_customer
    end

    it "returns an array of customers" do
      puts SalesEngine::Customer.find_all_by_first_name("John")
    end
  end

  describe 'test accessors' do
    SalesEngine::Customer::ATTRIBUTES.each do |attribute|
      context "responds to attr_accessors" do
        it "generates the reader" do
          test_customer.should be_respond_to("#{attribute}")
        end
        it "generates the writer" do
          test_customer.should be_respond_to("#{attribute}=")
        end
      end
    end
  end

  context "#invoices" do
    it "returns an array of Invoices" do
      invoices = test_customer.invoices
      invoices.each do |invoice|
        invoice.should be_is_a(SalesEngine::Invoice)
      end
    end
  end

  context "#transactions" do
    it "returns an array" do
      transactions = test_customer.transactions
      transactions.should be_is_a(Array)
    end

    it "returns an array of Transactions" do
      transactions = test_customer.transactions
      transactions.each do |invoice|
        invoice.should be_is_a(SalesEngine::Transaction)
      end
    end
  end

  context "#favorite_merchant" do
    it "returns a Merchant object" do
      fav_merchant = test_customer.favorite_merchant
      fav_merchant.should be_is_a(SalesEngine::Merchant)
    end
  end

   context "extensions" do

    describe "#days_since_activity" do
      it "returns a count of the days since the customer's last transaction" do
        Date.stub(:now => Date.parse("March 29, 2012"))
        Date.stub(:today => Date.parse("March 29, 2012"))
        days_since = SalesEngine::Customer.find_by_id(1).days_since_activity

        (days_since >= 3 || days_since <= 4).should be_true
      end
    end

    describe "#pending_invoices" do
      let(:pending) { SalesEngine::Customer.find_by_id(2).pending_invoices }
      context "when there are no pending invoices" do
        it "returns an empty array" do
          pending.should == []
        end
      end
      context "when there are pending invoices" do
        let(:first_invoice) { SalesEngine::Customer.find_by_id(2).invoices.first }
        it "returns an array of the pending invoices" do
          bad_transaction = SalesEngine::Transaction.random
          bad_transaction.stub(:result => "failed")
          first_invoice.stub(:transactions => [bad_transaction])

          pending.should == [first_invoice]
        end
      end
    end

    describe ".most_items" do
      it "returns the customer who has purchased the most items" do
        SalesEngine::Customer.most_items.id.should == 622
      end
    end

    describe ".most_revenue" do
      it "returns the customer who has generated the most total revenue" do
        SalesEngine::Customer.most_revenue.id.should == 601
      end
    end
  end
end