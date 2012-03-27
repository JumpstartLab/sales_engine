require 'spec_helper'

describe SalesEngine::FileParser do
  context "#parse" do
    let(:file_parser) { Fabricate(:file_parser) }

    it "exists" do
      file_parser.should respond_to :parse
    end

    it "raises an error given a nil filename" do
      expect { file_parser.parse(nil) }.to raise_error ArgumentError
    end

    context "returns" do
      before(:each) do
        @fake_csv = [{:id => 1, :name => 'Jonan'}]
        CSV.stub(:open => @fake_csv)
        File.stub(:exist? => true)
      end

      it "an array" do
        file_parser.parse('filename').should be_an Array
      end

      it "an array containing objects from a csv" do
        file_parser.parse('filename').should include @fake_csv[0]
      end
    end

    context "on an existing file" do
      before(:each) do
        @filename = 'spec/fixtures/merchants.csv'
      end

      it "returns the same number of objects as the file has lines" do
        length = File.open(@filename).to_a.length

        file_parser.parse(@filename).length.should be length - 1
      end

      it "returns hash objects" do
        file_parser.parse(@filename).first.should be_a Hash
      end
    end
  end
end
