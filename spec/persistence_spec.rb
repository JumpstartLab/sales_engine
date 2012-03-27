require 'spec_helper'

module SalesEngine
  class PersistenceSample
    include Model

    attr_accessor :name

    def initialize(attributes)
      super(attributes)
    end
  end
end

describe SalesEngine::Persistence do
  let(:model) { SalesEngine::PersistenceSample.new :id => 1, :name => 'Jonan' }

  before(:each) do
    SalesEngine::Persistence.instance.clear
  end

  context "#index" do
    it "creates an index for a given attribute" do
      model
      attribute = :id
      SalesEngine::Persistence.instance.index(attribute)
      indices = SalesEngine::Persistence.instance.dump_indices
      indices[model.class].keys.should include attribute
    end

    it "creates multiple indices for multiple attributes" do
      model
      attribute1 = :id
      attribute2 = :created_at
      SalesEngine::Persistence.instance.index(attribute1)
      SalesEngine::Persistence.instance.index(attribute2)
      indices = SalesEngine::Persistence.instance.dump_indices
      indices[model.class].keys.should include attribute1
      indices[model.class].keys.should include attribute2
    end

    it "writes a model to an index for a given attribute" do
      model
      attribute = :id
      SalesEngine::Persistence.instance.index(attribute)
      indices = SalesEngine::Persistence.instance.dump_indices
      indices[model.class][attribute][model.id].should be model
    end
  end

  context "#index_all" do
    it "returns true" do
      SalesEngine::Persistence.instance.index_all.should be_true
    end

    it "creates an index for each attribute of a persisted model" do
      model
      SalesEngine::Persistence.instance.index_all
      indices = SalesEngine::Persistence.instance.fetch_indices(model.class)
      attributes = model.attributes

      attributes.each do |attribute, value|
        indices.keys.should include attribute
      end
    end
  end

  context "#persist" do
    it "exists" do
      SalesEngine::Persistence.instance.should respond_to :persist
    end

    it "persists a model" do
      SalesEngine::Persistence.instance.persist(model)
      SalesEngine::Persistence.instance.exists?(model).should be_true
    end
  end

  context "#exists?" do
    it "exists" do
      SalesEngine::Persistence.instance.should respond_to :exists?
    end
  end

  context "#fetch" do
    it "returns an array" do
      SalesEngine::Persistence.instance.persist(model)
      SalesEngine::Persistence.instance.fetch(model.class).should be_an Array
    end

    it "returns an array including a persisted model" do
      SalesEngine::Persistence.instance.persist(model)
      SalesEngine::Persistence.instance.fetch(model.class).should include model
    end

    it "returns an empty array if there are no persisted models with the class" do
      result = SalesEngine::Persistence.instance.fetch(SalesEngine::PersistenceSample)
      result.should be_empty
    end
  end

  context "#fetch_indices" do
    it "returns a hash" do
      model
      SalesEngine::Persistence.instance.index(:id)
      SalesEngine::Persistence.instance.fetch_indices(model.class).should be_a Hash
    end
  end

  context "#clear" do
    it "removes all models and indices" do
      model
      SalesEngine::Persistence.instance.index(:id)
      SalesEngine::Persistence.instance.clear
      data = SalesEngine::Persistence.instance.fetch(model.class)
      indices = SalesEngine::Persistence.instance.dump_indices
      data.should be_empty
      indices.should be_empty
    end
  end

  context "#clear_indices" do
    it "clears the indices leaving data intact" do
      model
      SalesEngine::Persistence.instance.index(:id)
      SalesEngine::Persistence.instance.clear_indices
      data = SalesEngine::Persistence.instance.fetch(model.class)
      indices = SalesEngine::Persistence.instance.dump_indices
      data.should_not be_empty
      indices.should be_empty
    end
  end

  context "#clear_data" do
    it "clears the indices leaving data intact" do
      model
      SalesEngine::Persistence.instance.index(:id)
      SalesEngine::Persistence.instance.clear_data
      data = SalesEngine::Persistence.instance.fetch(model.class)
      indices = SalesEngine::Persistence.instance.dump_indices
      data.should be_empty
      indices.should_not be_empty
    end
  end
end
