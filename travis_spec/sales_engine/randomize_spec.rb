require 'spec_helper'

module SalesEngine
  class RandomizeSample
    extend Randomize

    def self.collection
      [
        DummyRandomizeObject.new(1),
        DummyRandomizeObject.new(2),
        DummyRandomizeObject.new(3)
      ]
    end
  end

  class DummyRandomizeObject
    attr_reader :id

    def initialize(object_id)
      @id = object_id
    end
  end
end

describe SalesEngine::Randomize do
  let(:sample) {SalesEngine::RandomizeSample.new}
  describe '.random' do
    context 'when iterating over a collection of objects' do
      it 'exists' do
        sample.class.random.should_not be_nil
      end
    end

    it 'returns an object from the collection' do
      result = sample.class.random.id
      [1,2,3].should include(result)
    end
  end

  it 'returns nil if the collection is empty' do
    empty_collection = []
    empty_collection.shuffle.first.should be_nil
  end
end
