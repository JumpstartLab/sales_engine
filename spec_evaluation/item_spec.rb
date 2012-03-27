require 'spec_helper'

describe SalesEngine::Item do
  context "Searching" do
    describe ".random" do
      it "usually returns different things on subsequent calls" do
        item_one =SalesEngine::Item.random
        10.times do
          item_two = SalesEngine::Item.random
          break if item_one.id != item_two.id
        end

        item_one.id.should_not == item_two.id
      end
    end

    describe ".find_by_unit_price" do
      it "can find one record" do
        item =SalesEngine::Item.find_by_unit_price 93519
        item.name.should == "Item Alias Nihil"
      end
    end

    describe ".find_all_by_name" do
      it "can find multiple records" do
        items = SalesEngine::Item.find_all_by_name "Item Eos Et"
        items.should have(3).items
      end
    end
  end

  context "Relationships" do
    let(:item) { SalesEngine::Item.find_by_name "Item Saepe Ipsum" }

    describe "#invoice_items" do
      it "has 8 of them" do
        item.invoice_items.should have(8).items
      end

      it "really owns them all" do
        item.invoice_items.each do |ii|
          ii.item_id.should == item.id
        end
      end
    end

    describe "#merchant" do
      it "exists" do
        item.merchant.name.should == "Kilback Inc"
      end
    end

  end

  context "Business Intelligence" do

    describe ".most_revenue" do
      it "returns the top n items ranked by most total revenue" do
        most = SalesEngine::Item.most_revenue(5)

        most.first.name.should == "Item Dicta Autem"
        most.last.name.should  == "Item Amet Accusamus"
      end
    end

    describe ".most_items" do
      it "returns the top n items ranked by most sold" do
        most = SalesEngine::Item.most_items(42)

        most.second.name.should == "Item Dicta Autem"
        most.last.name.should   == "Item Quidem Dolorum"
      end
    end

    describe "#best_day" do
      let(:item) { SalesEngine::Item.find_by_name "Item Accusamus Ut" }

      it "returns something castable to date" do
        date = Date.parse "Tue, 27 Mar 2012"
        item.best_day.to_date.should == date
      end
    end

  end
end
