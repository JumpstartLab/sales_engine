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
  let(:persistence) { SalesEngine::Persistence.instance }

  before(:each) do
    persistence.clear
  end

  context "#index" do
    it "creates an index for a given attribute" do
      model
      attribute = :id
      persistence.index(attribute)
      indices = persistence.dump_indices
      indices[model.class].keys.should include attribute
    end

    it "creates multiple indices for multiple attributes" do
      model
      attribute1 = :id
      attribute2 = :created_at
      persistence.index(attribute1)
      persistence.index(attribute2)
      indices = persistence.dump_indices
      indices[model.class].keys.should include attribute1
      indices[model.class].keys.should include attribute2
    end

    it "writes a model to an index for a given attribute" do
      model
      attribute = :id
      persistence.index(attribute)
      indices = persistence.dump_indices
      indices[model.class][attribute][model.id].first.should be model
    end
  end

  context "#index_all" do
    it "returns true" do
      persistence.index_all.should be_true
    end

    it "creates an index for each attribute of a persisted model" do
      model
      persistence.index_all
      indices = persistence.fetch_indices(model.class)
      attributes = model.attributes

      attributes.each do |attribute, value|
        indices.keys.should include attribute
      end
    end
  end

  context "#persist" do
    it "exists" do
      persistence.should respond_to :persist
    end

    it "persists a model" do
      persistence.persist(model)
      persistence.exists?(model).should be_true
    end
  end

  context "#exists?" do
    it "exists" do
      persistence.should respond_to :exists?
    end
  end

  context "#fetch" do
    it "returns an array" do
      persistence.persist(model)
      persistence.fetch(model.class).should be_an Array
    end

    it "returns an array including a persisted model" do
      persistence.persist(model)
      persistence.fetch(model.class).should include model
    end

    it "returns an empty array if there are no persisted models with the class" do
      result = persistence.fetch(SalesEngine::PersistenceSample)
      result.should be_empty
    end
  end

  context "#fetch_indices" do
    it "returns a hash" do
      model
      persistence.index(:id)
      persistence.fetch_indices(model.class).should be_a Hash
    end
  end

  context "#clear" do
    it "removes all models and indices" do
      model
      persistence.index(:id)
      persistence.clear
      data = persistence.fetch(model.class)
      indices = persistence.dump_indices
      data.should be_empty
      indices.should be_empty
    end
  end

  context "#clear_indices" do
    it "clears the indices leaving data intact" do
      model
      persistence.index(:id)
      persistence.clear_indices
      data = persistence.fetch(model.class)
      indices = persistence.dump_indices
      data.should_not be_empty
      indices.should be_empty
    end
  end

  context "#clear_data" do
    it "clears the indices leaving data intact" do
      model
      persistence.index(:id)
      persistence.clear_data
      data = persistence.fetch(model.class)
      indices = persistence.dump_indices
      data.should be_empty
      indices.should_not be_empty
    end
  end

  context "#dump_indices" do
    it "exists" do
      persistence.should respond_to :dump_indices
    end

    it "returns a hash" do
      persistence.dump_indices.should be_a Hash
    end
  end

  context "#dump_data" do
    it "exists" do
      persistence.should respond_to :dump_data
    end

    it "returns a hash" do
      persistence.dump_data.should be_a Hash
    end
  end
end
