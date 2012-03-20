require './spec/spec_helper'

describe SalesEngine::Item do
	describe ".get_items" do
		before(:each) { SalesEngine::Item.get_items }
		it "stores records from Item.csv in @@records" do
			SalesEngine::Item.records.map(&:class).uniq.should == [SalesEngine::Item]
		end
		it "stores an id" do
			SalesEngine::Item.records.first.id.should == '1'
		end
		it "stores a name" do
			SalesEngine::Item.records.first.name.should == "Item Necessitatibus Facilis"

		end
		it "stores a description" do
			SalesEngine::Item.records.first.description.length.should == 214
		end

		it "stores a unit_price" do
			SalesEngine::Item.records.first.unit_price.should == BigDecimal('161.80')
		end

	  it "stores a merchant_id" do
			SalesEngine::Item.records.first.merchant_id.should == "1"
		end

	end
end



#1,Item Necessitatibus Facilis,Omnis error accusantium est ea enim sint. Vero accusantium voluptatem natus et commodi deleniti. Autem soluta omnis in qui commodi. Qui corporis est ut blanditiis. Sit corrupti magnam sit dolores nostrum unde esse.,16180,1