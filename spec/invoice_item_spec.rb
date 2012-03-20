require './spec/spec_helper'

describe SalesEngine::InvoiceItem do
	describe ".get_invoice_items" do
		before(:each) { SalesEngine::InvoiceItem.get_invoice_items }
		it "stores records from invoice_item.csv in @@records" do
			SalesEngine::InvoiceItem.records.map(&:class).uniq.should == [SalesEngine::InvoiceItem]
		end
		it "stores an id" do
			SalesEngine::InvoiceItem.records.first.id.should == '1'
		end
		it "stores a item_id" do
			SalesEngine::InvoiceItem.records.first.item_id.should == "2138"

		end
		it "stores a invoice_id" do
			SalesEngine::InvoiceItem.records.first.invoice_id.should == "1"
		end
		it "stores a quantity" do
			SalesEngine::InvoiceItem.records.first.quantity.should == "1"
		end
		it "stores a unit_price" do
			SalesEngine::InvoiceItem.records.first.unit_price.should == BigDecimal("485.45")
		end

	end
end

# id,item_id,invoice_id,quantity,unit_price,created_at,updated_at
# 1,2138,1,1,48545,2012-02-26 20:56:56 UTC,2012-02-26 20:56:56 UTC