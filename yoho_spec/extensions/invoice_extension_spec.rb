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

    describe ".average_revenue" do
      it "returns the average of the totals of each invoice" do
        SalesEngine::Invoice.average_revenue.should == BigDecimal("11871.48")
      end
    end

    describe ".average_revenue(date)" do
      it "returns the average of the invoice revenues for that date" do
        SalesEngine::Invoice.average_revenue(DateTime.parse("March 17, 2012")).should == BigDecimal("11125.65")
      end
    end

    describe ".average_items" do
      it "returns the average of the number of items for each invoice" do
        SalesEngine::Invoice.average_items.should == BigDecimal("23")
      end
    end

    describe ".average_items(date)" do
      it "returns the average of the invoice items for that date" do
        SalesEngine::Invoice.average_items(DateTime.parse("March 21, 2012")).should == BigDecimal("23.41")
      end
    end
  end
end