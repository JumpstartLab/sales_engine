require './spec/spec_helper'

module SalesEngine
  class PersistenceSample
    include Model
  end
end

describe SalesEngine::Persistence do
  let(:model) { SalesEngine::PersistenceSample.new :id => 1 }

  before(:each) do
    SalesEngine::Persistence.instance.clear
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

  context "#clear" do
    it "removes all models" do
      SalesEngine::Persistence.instance.persist(model)
      SalesEngine::Persistence.instance.clear
      result = SalesEngine::Persistence.instance.fetch(model.class)
      result.should be_empty
    end
  end
end
