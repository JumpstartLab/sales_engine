require 'spec_helper.rb'
require 'date'

describe SalesEngine::Merchant do
  let(:merchant_one){ SalesEngine::Merchant.new( :id => "1" )}
  let(:merchant_two){ SalesEngine::Merchant.new( :id => "2" )}
  let(:merchant_three){ SalesEngine::Merchant.new( :id => "3" )}
  let(:inv_one)     { mock(SalesEngine::Invoice) }
  let(:inv_two)     { mock(SalesEngine::Invoice) }
  let(:inv_three)   { mock(SalesEngine::Invoice) }
  
  
  describe ".random" do
    before(:each) do
      merchants = [ merchant_one, merchant_two, merchant_three ]
      SalesEngine::Database.instance.stub(:merchant_list).and_return(merchants)
    end

    it "returns a random Merchant" do
      SalesEngine::Merchant.random.should be_a SalesEngine::Merchant
    end
  end

  describe "#invoices" do
    let(:inv_one){ SalesEngine::Invoice.new(:id => "1") }

    before(:each) do
      inv_one.stub(:merchant_id).and_return("1")
      inv_two.stub(:merchant_id).and_return("1")
      inv_three.stub(:merchant_id).and_return("2")
      invoices = [ inv_one, inv_two, inv_three ]

      SalesEngine::Database.instance.stub(:invoice_list).and_return(invoices)
    end

    it "returns a collection of invoices associated with the merchant" do
      merchant_one.invoices.should == [ inv_one, inv_two ]
    end

    context "when a merchant has no invoices" do
      it "returns an empty array" do
        merchant_three.invoices.should be_empty
      end
    end
  end

  describe "#items" do
    let(:item_one)   { mock(SalesEngine::Item) }
    let(:item_two)   { mock(SalesEngine::Item) }
    let(:item_three) { mock(SalesEngine::Item) }

    before(:each) do
      item_one.stub(:merchant_id).and_return("1")
      item_two.stub(:merchant_id).and_return("2")
      item_three.stub(:merchant_id).and_return("1")
      items = [ item_one, item_two, item_three ]

      SalesEngine::Database.instance.stub(:item_list).and_return(items)
    end

    it "returns a collection of items associated with the merchant" do
      merchant_one.items.should == [ item_one, item_three ]
    end

    context "when a merchant has no items" do
      it "returns an empty array" do
        merchant_three.items.should be_empty
      end
    end
  end

  describe "#invoices_on_date(date)" do
    before(:each) do
      inv_one.stub(:updated_at).and_return(Time.parse("2012-2-19"))
      inv_two.stub(:updated_at).and_return(Time.parse("2012-2-22"))
      inv_one.stub(:merchant_id).and_return("1")
      inv_two.stub(:merchant_id).and_return("1")
      invoices = [ inv_one, inv_two ]

      SalesEngine::Database.instance.stub(:invoice_list).and_return(invoices)
    end

    context "given a valid date" do
      it "returns all transactions on a date" do
        merchant_one.invoices_on_date("2012-2-19").should == [ inv_one ]
      end
    end
  end

  describe "#invoices_on_range(range)" do
    before(:each) do
      inv_one.stub(:updated_at).and_return(Time.parse("2012-2-19"))
      inv_two.stub(:updated_at).and_return(Time.parse("2012-2-22"))
      inv_three.stub(:updated_at).and_return(Time.parse("2012-2-24"))
      inv_one.stub(:merchant_id).and_return("1")
      inv_two.stub(:merchant_id).and_return("1")
      inv_three.stub(:merchant_id).and_return("1")
      invoices = [ inv_one, inv_two, inv_three ]

      SalesEngine::Database.instance.stub(:invoice_list).and_return(invoices)
    end

    context "given a valid date" do
      it "returns all transactions on a date" do
        date_range = Date.parse("2012-02-01")..Date.parse("2012-02-23")
        #does not handle edge case well.. FIX?
        merchant_one.invoices_on_range(date_range).should == [ inv_one, inv_two ]
      end
    end
  end

  describe "#revenue" do
    before(:each) do
      inv_one.stub(:invoice_revenue).and_return(BigDecimal.new("100"))
      inv_two.stub(:invoice_revenue).and_return(BigDecimal.new("100"))
    end

    context "when there are invoice_items" do
      it "returns total revenue for merchant" do
        merchant_one.stub( {:invoices => [ inv_one, inv_two ]} )
        merchant_one.revenue.should == 200
      end
    end
    context "when there are no invoice items" do
      it "returns 0" do
        merchant_one.stub( {:invoices => []} )
        merchant_one.revenue.should == 0
      end
    end
  end

  describe "#paid_invoices" do
    before(:each) do
      inv_one.stub(:is_successful?).and_return(true)
      inv_two.stub(:is_successful?).and_return(true)
      inv_three.stub(:is_successful?).and_return(false)

      invoices = [ inv_one, inv_two, inv_three ]
      merchant_one.stub(:invoices).and_return(invoices)
    end

    it "returns paid invoices associated with the merchant" do
      merchant_one.paid_invoices.should == [ inv_one, inv_two ]
    end

    context "when no paid transactions" do
      it "returns an empty array" do
        invoices = [ inv_three ]
        merchant_one.stub(:invoices).and_return(invoices)
        merchant_one.paid_invoices.should == [ ]
      end
    end
  end

  #WHAT IF THERE IS A TIE?
  describe "#favorite_customer" do
    let(:customer_one) { mock(SalesEngine::Customer, :id => "1") }
    let(:inv_one)      { mock(SalesEngine::Invoice, :customer_id => "1" ) }
    let(:inv_two)      { mock(SalesEngine::Invoice, :customer_id => "2" ) }
    let(:inv_three)    { mock(SalesEngine::Invoice, :customer_id => "1" ) }
    let(:invoices)     { [inv_one, inv_two, inv_three] }

    before(:each) do
      merchant_one.stub(:paid_invoices).and_return(invoices)
      merchant_two.stub(:paid_invoices).and_return([ ])
      SalesEngine::Database.instance.stub(:customer_list).and_return([customer_one])
    end

    it "returns the customer who has conducted the most successful transactions" do
      merchant_one.favorite_customer.should == customer_one
    end

    context "when there is no customer who has conducted a transaction" do
      it "returns nil" do
        merchant_two.favorite_customer.should == nil
      end
    end
  end

  describe "#customers_with_pending_invoices" do
    let(:inv_one)   { mock(SalesEngine::Invoice, :customer_id => "1", :is_successful? => true ) }
    let(:inv_two)   { mock(SalesEngine::Invoice, :customer_id => "2", :is_successful? => false) }
    let(:inv_three) { mock(SalesEngine::Invoice, :customer_id => "1", :is_successful? => false) }
    let(:invoices)  { [ inv_one, inv_two, inv_three ] }

    before(:each) do
      merchant_one.stub(:invoices).and_return( invoices )
    end

    it "returns all customers with pending invoices" do
      SalesEngine::Customer.should_receive(:find_by_id).with("2").and_return(:c2)
      SalesEngine::Customer.should_receive(:find_by_id).with("1").and_return(:c1)
      merchant_one.customers_with_pending_invoices.should == [:c2, :c1]
    end
  end

  describe ".clean_date" do
    context "when given a string" do
      it "returns a date" do
        SalesEngine::Merchant.clean_date("2012-02-19").should == Time.parse("2012-02-19")
      end
    end

    context "when given a date" do
      it "returns a date" do
        date = Time.parse("2012-02-19")
        SalesEngine::Merchant.clean_date(date).should == date
      end
    end
  end

  describe ".revenue(date)" do
    context "when date is single date" do
      it "calls total_revenue_on_date" do
        SalesEngine::Merchant.should_receive(:total_revenue_on_date).once
        SalesEngine::Merchant.revenue("2012-02-19")
      end
    end
    context "when date is a range" do
      it "calls total_revenue_on_range" do
        date_range = Date.parse("2012-02-01")..Date.parse("2012-02-20")
        SalesEngine::Merchant.should_receive(:total_revenue_on_range).once
        SalesEngine::Merchant.revenue(date_range)
      end
    end
  end

  describe ".total_revenue_on_date(date)" do
    before(:each) do
      inv_one.stub(:invoice_revenue).and_return(100)
      inv_two.stub(:invoice_revenue).and_return(200)
      inv_three.stub(:invoice_revenue).and_return(300)
      inv_one.stub(:updated_at).and_return(Time.parse("2012-02-19"))
      inv_two.stub(:updated_at).and_return(Time.parse("2012-02-21"))
      inv_three.stub(:updated_at).and_return(Time.parse("2012-02-19"))
      invoices = [ inv_one, inv_two, inv_three ]
      SalesEngine::Invoice.stub(:successful_invoices).and_return(invoices)
    end

    context "when given a date" do
      it "returns the total revenue across all merchants for that date" do
        SalesEngine::Merchant.total_revenue_on_date("2012-02-19").should == 400
      end
      context "when no transactions occurred on that date" do
        it "returns 0" do
          SalesEngine::Merchant.total_revenue_on_date("2012-02-20").should == 0
        end
      end
    end
  end

  describe ".total_revenue_on_range(range)" do
    before(:each) do
      inv_one.stub(:invoice_revenue).and_return(100)
      inv_two.stub(:invoice_revenue).and_return(200)
      inv_three.stub(:invoice_revenue).and_return(300)
      inv_one.stub(:updated_at).and_return(Time.parse("2012-02-19"))
      inv_two.stub(:updated_at).and_return(Time.parse("2012-02-21"))
      inv_three.stub(:updated_at).and_return(Time.parse("2012-02-19"))
      invoices = [ inv_one, inv_two, inv_three ]
      SalesEngine::Invoice.stub(:successful_invoices).and_return(invoices)
    end

    context "when given a date" do
      it "returns the total revenue across all merchants for that date" do
        date_range = Date.parse("2012-02-01")..Date.parse("2012-02-20")
        SalesEngine::Merchant.total_revenue_on_range(date_range).should == 400
      end
      context "when no transactions occurred on that date" do
        it "returns 0" do
          date_range = Date.parse("2012-02-22")..Date.parse("2012-03-01")
          SalesEngine::Merchant.total_revenue_on_range(date_range).should == 0
        end
      end
    end
  end

  describe ".merchants_by_revenue" do
    before(:each) do
      inv_one.stub(:invoice_revenue).and_return(100)
      inv_two.stub(:invoice_revenue).and_return(200)
      inv_three.stub(:invoice_revenue).and_return(300)
      inv_one.stub(:merchant_id).and_return("1")
      inv_two.stub(:merchant_id).and_return("2")
      inv_three.stub(:merchant_id).and_return("1")
      invoices = [ inv_one, inv_two, inv_three ]
      SalesEngine::Invoice.stub(:successful_invoices).and_return(invoices)
    end

    it "returns a hash with merchant_ids as keys and revenue as values" do
      revenue_hash = { :"1" => 400, :"2" => 200 }
      SalesEngine::Merchant.merchants_by_revenue.should == revenue_hash
    end

    context "when no successful transactions" do
      it "returns nil" do
        invoices = [ ]
        SalesEngine::Invoice.stub(:successful_invoices).and_return(invoices)
        SalesEngine::Merchant.merchants_by_revenue.should be_empty
      end
    end
  end

  # Need to create a merchant item data method
  describe ".merchants_by_items_sold" do
    let(:inv_item_one) { mock(SalesEngine::InvoiceItem) }
    let(:inv_item_two) { mock(SalesEngine::InvoiceItem) }
    let(:inv_item_three) { mock(SalesEngine::InvoiceItem) }

    before(:each) do
      inv_item_one.stub(:merchant_id).and_return("1")
      inv_item_two.stub(:merchant_id).and_return("2")
      inv_item_three.stub(:merchant_id).and_return("1")
      inv_item_one.stub(:quantity).and_return(10)
      inv_item_two.stub(:quantity).and_return(20)
      inv_item_three.stub(:quantity).and_return(30)
      inv_items = [ inv_item_one, inv_item_two, inv_item_three ]
      SalesEngine::InvoiceItem.stub(:successful_invoice_items).and_return(inv_items)
    end

    it "returns hash with merchant_id as keys and the total qty sold as values" do
      SalesEngine::Merchant.merchants_by_items_sold.should == { :"1" => 40, :"2" => 20 }
    end
  end


  describe ".most_items(num)" do
    before(:each) do
      merchants = [merchant_one, merchant_two, merchant_three ]
      SalesEngine::Database.instance.stub(:merchant_list).and_return(merchants)
    end

    it "returns the num merchants who have sold the most" do
      item_hash = { :"1" => 10, :"2" => 20, :"3" => 30 }
      SalesEngine::Merchant.stub(:merchants_by_items_sold).and_return(item_hash)
      sorted_merchants = [ merchant_three, merchant_two ]
      SalesEngine::Merchant.most_items(2).should == sorted_merchants
    end

    # TIE CASE NOT WORKING... REVISIT
    # context "when there is a tie" do
    #   it "returns num merchants ranked by most rev, then id" do
    #     item_hash = { :"1" => 20, :"2" => 20, :"3" => 30 }
    #     SalesEngine::Merchant.stub(:merchants_by_items_sold).and_return(item_hash)
    #     sorted_merchants = [  merchant_three, merchant_one, merchant_two ]
    #     SalesEngine::Merchant.most_items(3).should == sorted_merchants
    #   end
    # end
  end

  describe ".most_revenue(num)" do

    before(:each) do
      merchants = [merchant_one, merchant_two, merchant_three ]
      SalesEngine::Database.instance.stub(:merchant_list).and_return(merchants)
    end

    it "returns the top x merchants" do
      sorted_merchants = [ merchant_one, merchant_three, merchant_two ]
      revenue_hash = { :"1" => 400, :"2" => 200, :"3" => 300 }
      SalesEngine::Merchant.stub(:merchants_by_revenue).and_return(revenue_hash)
      SalesEngine::Merchant.most_revenue(3).should == sorted_merchants
    end

    context "when there is a tie" do
      it "returns num merchants ranked by most rev, then id" do
        revenue_hash = { :"1" => 400, :"2" => 600, :"3" => 400 }
        SalesEngine::Merchant.stub(:merchants_by_revenue).and_return(revenue_hash)
        sorted_merchants = [ merchant_two, merchant_one, merchant_three ]
        SalesEngine::Merchant.most_revenue(3).should == sorted_merchants
      end
    end
  end

  describe ".revenue_on_dates" do
    before(:each) do
      inv_one.stub(:updated_at).and_return(Time.parse("2012-02-19"))
      inv_two.stub(:updated_at).and_return(Time.parse("2012-02-20"))
      inv_three.stub(:updated_at).and_return(Time.parse("2012-02-19"))
      inv_one.stub(:invoice_revenue).and_return("100")
      inv_two.stub(:invoice_revenue).and_return("150")
      inv_three.stub(:invoice_revenue).and_return("100")

      invoices = [ inv_one, inv_two, inv_three ]
      SalesEngine::Invoice.stub(:successful_invoices).and_return(invoices)
    end

    it "returns a hash with dates as keys and revenue as values" do
      result = { Time.parse("2012/02/19").strftime("%Y/%m/%d") => 200 ,
                 Time.parse("2012/02/20").strftime("%Y/%m/%d") => 150 }
      SalesEngine::Merchant.revenue_on_dates.should == result
    end
  end

  describe ".dates_by_revenue(num)" do
    before(:each) do
      result = { Time.parse("2012/02/19").strftime("%Y/%m/%d") => 200 ,
                 Time.parse("2012/02/20").strftime("%Y/%m/%d") => 150 }
      SalesEngine::Merchant.stub(:revenue_on_dates).and_return(result)
    end

    it "returns an array of dates sorted by revenue" do
      result = [ Date.parse("2012/02/19"),
                 Date.parse("2012/02/20") ]
      SalesEngine::Merchant.dates_by_revenue.should == result
    end

    context "if given a num" do
      it "returns the first num dates" do
        result = [ Date.parse("2012/02/19"),
                   Date.parse("2012/02/20") ]
        SalesEngine::Merchant.dates_by_revenue(1).should == [ result.first ]
      end
    end
  end
end