require './spec/spec_helper'

describe SalesEngine::CSVLoader do
  describe ".load" do
    context "loads a non-empty CSV file" do
      let(:raw_lines) { SalesEngine::CSVLoader.load('./spec/test_data.csv') }
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
        expect{SalesEngine::CSVLoader.load('./spec/empty.csv')}.to_not raise_error
      end
      it "returns an empty array" do
        SalesEngine::CSVLoader.load('./spec/empty.csv').should == []
      end
    end
  end
end