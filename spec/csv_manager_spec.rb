require './spec/spec_helper'

describe SalesEngine::CSVManager do
  describe ".load" do
    context "loads a non-empty CSV file" do
      let(:raw_lines) { SalesEngine::CSVManager.load('./spec/test_data.csv') }
      it "returns an array" do
        raw_lines.should be_an Array
      end

      it "returns an array of hashes" do
        raw_lines.map(&:class).uniq.should == [Hash]
      end


      it "provides data from the csv file" do
        raw_lines.first[:favorite_color].should == 'blue'
        raw_lines.last[:height].should == "120 inches"
      end

      it "provides all of the records" do
        raw_lines.size.should == 3
      end
    end
    context "loads an empty CSV file" do
      it "doesn't raise an error" do
        expect{SalesEngine::CSVManager.load('./spec/empty.csv')}.to_not raise_error
      end
      it "returns an empty array" do
        SalesEngine::CSVManager.load('./spec/empty.csv').should == []
      end
    end
  end
  describe ".save" do
    context "saves all files to their _output counterpart" do
      before(:all) { SalesEngine::CSVManager.save }
      it "saves all merchant records to merchant_output.csv" do
        SalesEngine::CSVManager.load('data/merchants.csv').should == SalesEngine::CSVManager.load('data/merchant_output.csv')
      end
      it "saves all customer records to customer_output.csv" do
        SalesEngine::CSVManager.load('data/customers.csv').should == SalesEngine::CSVManager.load('data/customer_output.csv')
      end
      it "saves all invoice records to invoice_output.csv" do
        SalesEngine::CSVManager.load('data/invoices.csv').should == SalesEngine::CSVManager.load('data/invoice_output.csv')
      end
      it "saves all invoice_item records to invoice_item_output.csv" do
        SalesEngine::CSVManager.load('data/invoice_items.csv').should == SalesEngine::CSVManager.load('data/invoice_item_output.csv')
      end
      it "saves all item records to item_output.csv" do
        SalesEngine::CSVManager.load('data/items.csv').should == SalesEngine::CSVManager.load('data/item_output.csv')
      end
      it "saves all transaction records to transaction_output.csv" do
        SalesEngine::CSVManager.load('data/transactions.csv').should == SalesEngine::CSVManager.load('data/transaction_output.csv')
      end
    end
  end
end