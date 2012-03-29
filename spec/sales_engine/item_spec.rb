require 'spec_helper'

describe SalesEngine::Item do
  param = {:id => 1,
           :name => "Item Necessitatibus Facilis",
           :description => "Omnis error accusantium est ea enim sint.
            Vero accusantium voluptatem natus et commodi deleniti.
            Autem soluta omnis in qui commodi. Qui corporis est ut
            blanditiis. Sit corrupti magnam sit dolores nostrum
            unde esse.",
           :unit_price => 16180,
           :merchant_id => 1,
           :created_at => "2012-02-26 20:56:50 UTC",
           :updated_at => "2012-02-26 20:56:50 UTC"}
  let(:item) {SalesEngine::Item.new(param)}
  describe '#initialize' do
    context "when instantiating a new item" do
      it 'receives a hash as a param' do
        param.should be_a(Hash)
      end
      [:id, :name, :description, :unit_price, :merchant_id,
        :created_at, :updated_at].each do |method|
        it "sets the item's attribute #{method} with the method #{method}" do
          item.send(method).should_not be_nil
        end
      end
    end
  end

  let(:collection) {SalesEngine::Database.instance.items}
  describe '.collection' do
    it 'creates an array' do
      collection.should be_a(Array)
    end
    it 'contains instances of the item class' do
      collection.first.class.should == item.class
    end
    it 'is not empty' do
      collection.should_not be_empty
    end
  end

  describe '.database' do
    it 'proxies to Database' do
      SalesEngine::Database.should_receive(:instance)
      SalesEngine::Item.database
    end
  end

  describe '#database' do
    it 'proxies to Database' do
      SalesEngine::Database.should_receive(:instance)
      item.database
    end
  end

  describe '#database=' do
    it 'proxies to Database' do
      SalesEngine::Database.should_receive(:instance)
      item.database
    end
  end

  let(:invoiceitem){SalesEngine::Database.instance.invoiceitems[0]}
  let(:items){SalesEngine::Database.instance.items}
  describe '#invoice_items' do
    it 'creates an array' do
      item.invoice_items.should be_a(Array)
    end
    it 'returns an instance of invoice item' do
      array_of_invoiceitems = items[0].invoice_items
      array_of_invoiceitems[0].class.should == SalesEngine::InvoiceItem
    end
    it 'returns an empty array when no match' do
      item.invoice_items.should == []
    end
    it 'produces invoice items whose item_id
        matches the instantiated item\'s id' do
      test_invoiceitem = items[0].invoice_items.first
      test_invoiceitem.item_id.should == items[0].id
    end
  end

  describe '#merchant' do
    it 'returns a matched Merchant' do
      items[0].merchant.class.should == SalesEngine::Merchant
    end
  end

  describe '#match_merchant_to_item' do
    it 'produces a merchant whose id matches
        the instantiated item\'s merchant_id' do
      test_merchant = items[0].merchant
      test_merchant.id.should == items[0].merchant_id
    end
  end

  describe '#revenue' do
    it 'calculates revenue for each matched invoice item' do
      inv_items = items[0].invoice_items
      sum = inv_items.inject(0){
        |acc,num| (num.quantity.to_i * num.unit_price.to_i) + acc
      }
      items[0].revenue.should == sum
    end
  end

  describe '.sort_by_revenue' do
    pending
    # it 'returns a sorted collection' do
    #   raise (result = SalesEngine::Item.sort_by_revenue).inspect
    #   # result.first > result.last.should be > result.last
    # end
  end

  describe '.most_revenue' do
    context "when given a number as an argument" do
      it 'returns an array' do
        result = SalesEngine::Item.most_revenue(5)
        result.count.should == 5
      end
      it 'returns items' do
        result = SalesEngine::Item.most_revenue(5)
        result.first.class.should == SalesEngine::Item
      end
    end

    context "when no argument is given" do
      it "returns a single item" do
        result = SalesEngine::Item.most_revenue
        result.should be_instance_of(SalesEngine::Item)
      end
    end
  end

  describe '#items_quantity' do
    it 'returns total quantity for an item' do
      results = items[0].items_quantity
      add = items[0].invoice_items.inject(0){
        |acc,num| num.quantity.to_i + acc
      }
      results.should == add
    end
  end

  describe '.sort_by_items' do
    pending
  #   it 'returns largest quantity first' do
  #     result = SalesEngine::Item.sort_by_items
  #     result.first.should be > result.last
  #   end
  end

  describe '.most_items(x)' do
    context "when given a number as an argument" do
      it 'returns an array' do
        result = SalesEngine::Item.most_items(5)
        result.count.should == 5
      end
      it 'returns items' do
        result = SalesEngine::Item.most_items(5)
        result.first.class.should == SalesEngine::Item
      end
    end

    context "when no argument is given" do
      it "returns a single item" do
        result = SalesEngine::Item.most_items
        result.should be_instance_of(SalesEngine::Item)
      end
    end
  end

  describe '#best_day' do
    it '' do
      pending
    end
  end

end