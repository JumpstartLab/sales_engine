require 'spec_helper'

describe Item do
  context "Searching" do
    describe ".random" do
      it "usually returns different things on subsequent calls" do
        item_one = Item.random
        10.times do
          item_two = Item.random
          break if item_one != item_two
        end

        item_one.should_not == item_two
      end
    end

    describe ".find_by_unit_price" do
      item = Item.find_by_unit_price 53307
      item.name.should == "Item Sit Numquam"
    end

    describe ".find_all_by_name" do
      items = Item.find_all_by_name "Item Voluptatum Odio"
      items.should have(1).items
    end
  end

  context "Relationships" do
    let(:item) { Item.find_by_name "Item Vero Blanditiis" }

    describe "#invoice_items" do
      it "has 6 of them" do
        item.invoice_items.should have(6).items
      end

      it "really owns them all" do
        item.invoice_items.each do |ii|
          ii.item_id.should == item.id
        end
      end
    end

    describe "#merchant" do
      it "exists" do
        item.merchant.name.should == "Trantow-Dooley"
      end
    end

  end

  context "Business Intelligence" do

    describe ".most_revenue" do
      it "returns the top n items ranked by most total revenue" do
        most = Item.most_revenue(5)

        most.first.name.should == "Item Consectetur Aut"
        most.last.name.should  == "Item Amet Molestiae"
      end
    end

    describe ".most_items" do
      it "returns the top n items ranked by most sold" do
        most = Item.most_items(42)

        most.second.name.should == "Item Veritatis Ut"
        most.last.name.should   == "Item Similique Ad"
      end
    end

    describe "#best_day" do
      let(:item) { Item.find_by_name "Item Vero Blanditiis" }

      it "returns something castable to date" do
        date = Date.parse "Tue, 20 Mar 2012"
        item.best_day.to_date.should == date
      end
    end

  end
end
