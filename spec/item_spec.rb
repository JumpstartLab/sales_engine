require './spec/spec_helper'

describe SalesEngine::Item do
	describe ".get_items" do
		before(:all) { SalesEngine::Item.get_items }
		it "stores records from Item.csv in @@records" do
			SalesEngine::Item.records.map(&:class).uniq.should == [SalesEngine::Item]
		end
		{id: 1, name: "Item Necessitatibus Facilis",
		unit_price: BigDecimal('161.80'),
		merchant_id: 1,}.each do |attribute, value|
			it "records #{attribute}" do
				SalesEngine::Item.records.first.send(attribute).should == value
			end
		end

		it "stores a description" do
			SalesEngine::Item.records.first.description.length.should == 214
		end
	end

	context "instance methods" do
		let(:item) { SalesEngine::Item.find_by_id(1) }
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
				item.merchant.should == SalesEngine::Merchant.find_by_id(1)
			end
		end
	end

	context "business intelligence methods" do
		describe ".most_revenue" do
			it "returns an array of Items" do
				SalesEngine::Item.most_revenue(1).first.should be_a(SalesEngine::Item)
			end
			it "returns items sorted by descending revenue" do
				item_a = SalesEngine::Item.find_by_id(2382)
				item_b = SalesEngine::Item.find_by_id(1824)
				item_c = SalesEngine::Item.find_by_id(401)
				SalesEngine::Item.most_revenue(3).should == [ item_a, item_b, item_c ]
			end
		end
		describe ".most_items" do
			it "returns an array of items" do
				SalesEngine::Item.most_items(1).first.should be_a(SalesEngine::Item)
			end
			it "returns items sorted by descending amount sold" do
				item_a = SalesEngine::Item.find_by_id(2186)
				item_b = SalesEngine::Item.find_by_id(524)
				item_c = SalesEngine::Item.find_by_id(1015)
				SalesEngine::Item.most_items(3).should == [ item_a, item_b, item_c ]
			end
		end
		describe "#best_day" do
			it "returns the date with the most sales for this item" do
				# pending
				SalesEngine::Item.find_by_id(1).best_day.should == DateTime.parse("2012-02-19T20:57:09+00:00").strftime("%d%m%y")
			end
		end

	end
end

#id,name,description,unit_price,merchant_id,created_at,updated_at
#1,Item Necessitatibus Facilis,Omnis error accusantium est ea enim sint. Vero accusantium voluptatem natus et commodi deleniti. Autem soluta omnis in qui commodi. Qui corporis est ut blanditiis. Sit corrupti magnam sit dolores nostrum unde esse.,16180,1
