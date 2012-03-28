require 'spec_helper'

describe SalesEngine::Invoice, invoice: true do
  context "extensions" do
    describe ".pending" do
      it "returns Invoices without a successful transaction" do
        invoice =  SalesEngine::Invoice.find_by_id(13)
        pending_invoices = SalesEngine::Invoice.pending

        pending_invoices[1].should == invoice
      end
    end

    before(:each) do
      @mock_invoices = []
      3.times do | i |
        fake_invoice = double("invoice")
        fake_invoice.stub(:successful_transaction => true)
        fake_invoice.stub(:total_paid => (i * 3))
        @mock_invoices << fake_invoice
      end
    end

    describe ".average_revenue" do
      it "returns the average of the totals of each invoice" do
        SalesEngine::Invoice.stub(:records => @mock_invoices)
        SalesEngine::Invoice.average_revenue.should == BigDecimal("3")
      end
    end

    describe ".average_revenue(date)" do
      it "returns the average of the invoice revenues for that date" do
        @mock_invoices.each { |mi| mi.stub(:created_at => DateTime.now) }
        @mock_invoices[0].stub(:created_at => DateTime.parse("Jan 1, 2012"))
        SalesEngine::Invoice.stub(:records => @mock_invoices)

        SalesEngine::Invoice.average_revenue(DateTime.now).should == BigDecimal("4.5")
      end
    end

    describe ".average_items" do
      it "returns the average of the number of items for each invoice" do
        @mock_invoices.each_with_index  do |mi, i|
          mi.stub(:successful_transaction => true)
          mi.stub(:num_items => (i * 3))
        end
        SalesEngine::Invoice.stub(:records => @mock_invoices)

        SalesEngine::Invoice.average_items.should == BigDecimal("3")
      end
    end

    describe ".average_items(date)" do
      it "returns the average of the invoice items for that date" do
        @mock_invoices.each_with_index  do |mi, i|
          mi.stub(:successful_transaction => true)
          mi.stub(:num_items => (i * 3))
          mi.stub(:created_at => DateTime.now)
        end
        @mock_invoices[2].stub(:created_at => DateTime.parse("Jan 1, 2012"))
        SalesEngine::Invoice.stub(:records => @mock_invoices)

        SalesEngine::Invoice.average_items(DateTime.now).should == BigDecimal("1.5")
      end
    end
  end
end