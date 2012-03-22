require 'spec_helper'

describe SalesEngine::Merchant do
  describe "#invoices" do
    let(:invoice1) { mock(SalesEngine::Invoice) }
    let(:invoice2) { mock(SalesEngine::Invoice) }
    let(:invoice3) { mock(SalesEngine::Invoice) }

    before(:each) do
      invoice1.stub(:merchant_id).and_return(1)
      invoice2.stub(:merchant_id).and_return(2)
      invoice3.stub(:merchant_id).and_return(1)

      invoices = [invoice1, invoice2, invoice3]
      SalesEngine::Database.stub(:invoices).and_return(invoices)
    end


    context "when merchant has one invoice" do
      it "returns an array containing the single invoice" do
        merchant = SalesEngine::Merchant.new(2, "", "", "")
        merchant.invoices.should == [invoice2]
      end
    end

    context "when merchant has multiple invoices" do
      it "returns all invoices" do
        merchant = SalesEngine::Merchant.new(1, "", "", "")
        merchant.invoices.should == [invoice1, invoice3]
      end
    end

    context "when merchant has no invoices" do
      it "returns an empty array" do
        merchant = SalesEngine::Merchant.new(3, "", "", "")
        merchant.invoices.should == []
      end
    end
  end

  describe "#items" do
    let(:item1) { mock(SalesEngine::Item) }
    let(:item2) { mock(SalesEngine::Item) }
    let(:item3) { mock(SalesEngine::Item) }

    before(:each) do
      item1.stub(:merchant_id).and_return(1)
      item2.stub(:merchant_id).and_return(2)
      item3.stub(:merchant_id).and_return(1)

      items = [item1, item2, item3]
      SalesEngine::Database.stub(:items).and_return(items)
    end


    context "when merchant has one item" do
      it "returns an array containing the single item" do
        merchant = SalesEngine::Merchant.new(2, "", "", "")
        merchant.items.should == [item2]
      end
    end

    context "when merchant has multiple items" do
      it "returns all items" do
        merchant = SalesEngine::Merchant.new(1, "", "", "")
        merchant.items.should == [item1, item3]
      end
    end

    context "when merchant has no items" do
      it "returns an empty array" do
        merchant = SalesEngine::Merchant.new(3, "", "", "")
        merchant.items.should == []
      end
    end
  end

  describe "#invoice_items" do
    let(:invoice_item) { mock(SalesEngine::InvoiceItem)}
    let(:invoice_item2) { mock(SalesEngine::InvoiceItem)}
    let(:other_invoice_item) { mock(SalesEngine::InvoiceItem)}
    let(:invoices) { mock(Array) }

    let(:invoice) { mock(SalesEngine::Invoice) }
    let(:invoice2) { mock(SalesEngine::Invoice) }
    let(:merchant) { SalesEngine::Merchant.new(3, "", "", "") }

    before(:each) do
      invoice.stub(:invoice_items).and_return([invoice_item, other_invoice_item])
      invoice2.stub(:invoice_items).and_return([invoice_item2])
    end

    context "when there are invoices" do
      it "returns invoice items" do
        SalesEngine::Database.stub(:invoices).and_return(invoices)      
        invoices.stub(:select).and_return([invoice, invoice2])
        merchant = SalesEngine::Merchant.new(3, "", "", "")
        merchant.invoice_items.should == [invoice_item, other_invoice_item, invoice_item2]
      end

      context "when there are no invoices" do
        it "return no invoice items" do
          SalesEngine::Database.stub(:invoices).and_return([])      
          merchant.invoice_items.should == []
        end
      end
    end
  end

  describe "#revenue" do
    let(:invoice_item) { mock(SalesEngine::InvoiceItem)}
    let(:invoice_item2) { mock(SalesEngine::InvoiceItem)}
    let(:other_invoice_item) { mock(SalesEngine::InvoiceItem)}
    # let(:invoices) { mock(Array) }

    # let(:invoice) { mock(SalesEngine::Invoice) }
    # let(:invoice2) { mock(SalesEngine::Invoice) }
    let(:merchant) { SalesEngine::Merchant.new(3, "", "", "") }

    before(:each) do
      invoice_item.stub(:unit_price).and_return(BigDecimal.new("100"))
      invoice_item.stub(:quantity).and_return(BigDecimal.new("1"))
      invoice_item2.stub(:unit_price).and_return(BigDecimal.new("200"))
      invoice_item2.stub(:quantity).and_return(BigDecimal.new("2"))
      other_invoice_item.stub(:unit_price).and_return(BigDecimal.new("300"))
      other_invoice_item.stub(:quantity).and_return(BigDecimal.new("3"))

      # invoice.stub(:invoice_items).and_return([invoice_item, other_invoice_item])
      # invoice2.stub(:invoice_items).and_return([invoice_item2])
    end

    context "when there are invoice_items" do
      # class SalesEngine::Merchant 
      #   def invoice_items
      #     [invoice_item, invoice_item2, other_invoice_item]
      #   end
      # end
      # SalesEngine::Database.stub(:invoices).and_return(invoices)
      it "returns total revenue for merchant" do
        SalesEngine::Merchant.any_instance.stub({:invoice_items => [invoice_item, invoice_item2, other_invoice_item]})
        merchant.revenue.should == 1400 
      end
    end
  end
  # describe "#revenue" do
  #   let(:merchant) { Merchant.new(1, "", Date.today, Date.today) }

  #   context "when merchant has invoices" do
  #     it "returns revenue" do
  #     end
  #   end

  #   context "when merchant has no invoices" do

  #   end
  # end
  # describe ".most_revenue(x)" do
  #   let(:merchant) { mock(Merchant) }
  #   let(:merchant2) { mock(Merchant) }
  #   let(:merchant3) { mock(Merchant) }


  #   context "when x is a positive number" do
  #     it "returns an array of x length" do
  #       SalesEngine::Merchant.most_revenue(3).size.should == 3 
  #     end

  #     context "when x is 1" do
  #       it "returns an array of the merchant with the highest revenue" do
  #       SalesEngine::Merchant.most_revenue(1).should == [merchant2]
  #       end
  #     end
  #   end

  #   context "when x is not positive" do
  #     it "returns an empty array" do
  #       SalesEngine::Merchant.most_revenue(0).should == []
  #     end    

  #     it "returns an empty array" do
  #       SalesEngine::Merchant.most_revenue(-10).should == []
  #     end    
  #   end
  #end
end