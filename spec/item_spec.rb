require './spec/spec_helper'

describe SalesEngine::Item do
	describe ".get_items" do
		before(:all) { SalesEngine::Item.get_items }
		it "stores records from Item.csv in @@records" do
			SalesEngine::Item.records.map(&:class).uniq.should == [SalesEngine::Item]
		end
		{id: "1", name: "Item Necessitatibus Facilis",
		unit_price: BigDecimal('161.80'),
		merchant_id: "1",}.each do |attribute, value|
			it "records #{attribute}" do
				SalesEngine::Item.records.first.send(attribute).should == value
			end
		end

		it "stores a description" do
			SalesEngine::Item.records.first.description.length.should == 214
		end
	end

	context "instance methods" do
		let(:item) { SalesEngine::Item.find_by_id('1') }
		describe "#invoice_items" do
			it "returns an array of invoice_items" do
				item.invoice_items.should_not be_empty
				item.invoice_items.first.should be_a(SalesEngine::InvoiceItem)
			end
			it "returns the invoice_items associated with this item" do
				item.invoice_items.size.should == 10
			end
		end
		describe "#merchant" do
			it "returns a merchant" do
				item.merchant.should be_a(SalesEngine::Merchant)
			end
			it "returns its merchant" do
				item.merchant.should == SalesEngine::Merchant.find_by_id('1')
			end
		end
	end
end

#id,name,description,unit_price,merchant_id,created_at,updated_at
#1,Item Necessitatibus Facilis,Omnis error accusantium est ea enim sint. Vero accusantium voluptatem natus et commodi deleniti. Autem soluta omnis in qui commodi. Qui corporis est ut blanditiis. Sit corrupti magnam sit dolores nostrum unde esse.,16180,1
