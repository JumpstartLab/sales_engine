require 'spec_helper'

module SalesEngine
  class SearchableSample
    extend Searchable

    def self.collection
      [
        DummySearchableObject.new(:foo => "Verdi"),
        DummySearchableObject.new(:foo => "Verdi"),
        DummySearchableObject.new(:foo => "Jonan"),
        DummySearchableObject.new(:foo => "Travis")
      ]
    end
  end

  class DummySearchableObject
    attr_reader :foo

    def initialize(attributes)
      @foo = attributes[:foo]
    end

  end
end

describe SalesEngine::Searchable do
  describe '.find_by_' do
    let(:sample) {SalesEngine::SearchableSample.new}
    it "exists" do
      sample.class.find_by_(:foo, "Jonan").should_not be_nil
    end
    it "returns a matching value" do
      result = sample.class.find_by_(:foo, "Verdi")
      result.foo.should == "Verdi"
    end
    it "returns nil when no match found" do
      sample.class.find_by_(:foo, "Carl").should be_nil
    end
    it "returns no method error when invalid key" do
      expect{sample.class.find_by_(:person, "Carl")}.should raise_error
    end
  end

  describe '.find_all_by_' do
    let(:sample) {SalesEngine::SearchableSample.new}
    it "exists" do
      sample.class.find_all_by_(:foo, "Jonan").should_not be_nil
    end
    it "returns all matching values" do
      results = sample.class.find_all_by_(:foo, "Verdi")
      results.map { |result| result.foo }.should == ["Verdi", "Verdi"]
    end
    it "returns empty array when no match found" do
      sample.class.find_all_by_(:foo, "Carl").should == []
    end
    it "returns no method error when invalid key" do
      expect{sample.class.find_all_by_(:person, "Carl")}.should raise_error
    end
  end

end