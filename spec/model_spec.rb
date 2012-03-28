require 'spec_helper'

module SalesEngine
  class ModelSample
    include Model
  end
end

describe SalesEngine::Model do
  let(:valid_sample) { SalesEngine::ModelSample.new :id => 1 }

  before(:each) do
    SalesEngine::Persistence.instance.clear
  end

  it "persists a new model" do
    valid_sample
    SalesEngine::Persistence.instance.exists?(valid_sample).should be_true
  end

  context "id attribute" do
    it "doesn't create a model with a nil id" do
      expect do
        SalesEngine::ModelSample.new(:id => nil) 
      end.to raise_error(ArgumentError)
    end

    it "has an id" do
      valid_sample.id.should_not be_nil
    end

    it "doesn't create a model with a blank id" do
      expect do
        SalesEngine::ModelSample.new(:id => "") 
      end.to raise_error(ArgumentError)
    end

    it "raises an error when given a float id" do
      expect do
        SalesEngine::ModelSample.new :id => 1.5 
      end.to raise_error ArgumentError
    end

    it "converts a string id to an integer" do
      SalesEngine::ModelSample.new(:id => '1').should_not be_nil
    end
  end

  context "created_at" do
    it "responds to created_at" do
      valid_sample.should be_respond_to(:created_at)  
    end

    it "returns a DateTime object when created_at is called" do
      valid_sample.created_at.should be_a DateTime
    end

    it "is assigned when passed a DateTime argument" do
      date = DateTime.now
      valid_sample = SalesEngine::ModelSample.new(:id => 1, :created_at => date)
      valid_sample.created_at.should == date
    end

    it "converts a string created_at to a DateTime object" do
      string_date_sample = SalesEngine::ModelSample.new(:id => 1, :created_at => '2012-03-27T16:25:22-04:00')
      string_date_sample.created_at.should be_a DateTime
    end

    it "converts a string updated_at to a DateTime object" do
      string_date_sample = SalesEngine::ModelSample.new(:id => 1, :updated_at => '2012-03-27T16:25:22-04:00')
      string_date_sample.updated_at.should be_a DateTime
    end
  end

  context "updated_at attribute" do
    it "responds to updated_at" do
      valid_sample.should be_respond_to(:updated_at)  
    end

    it "returns a DateTime object when updated_at is called" do
      valid_sample.updated_at.should be_a DateTime
    end

    it "assigns updated_at when passed a DateTime argument" do
      date = DateTime.now
      valid_sample = SalesEngine::ModelSample.new(:id => 1, :updated_at => date)
      valid_sample.updated_at.should == date
    end

    it "assigns updated_at to created_at for a new valid_sample" do
      valid_sample.created_at.should == valid_sample.updated_at
    end
  end

  context ".find" do
    it "exists" do
      SalesEngine::ModelSample.should respond_to :find
    end

    it "returns a model with a given id" do
      valid_sample
      SalesEngine::ModelSample.find(1).should be valid_sample
    end

    it "should use an index if one exists" do
      valid_sample
      SalesEngine::Persistence.instance.stub(:fetch_indices => {})
      SalesEngine::Persistence.instance.index(:id)
      SalesEngine::Persistence.instance.should_receive(:fetch_indices).with(valid_sample.class)
      valid_sample.class.find(valid_sample.id)
    end
  end

  context ".find_all" do
    it "exists" do
      SalesEngine::ModelSample.should respond_to :find_all
    end

    it "returns all persisted models of the calling class" do
      valid_sample
      SalesEngine::ModelSample.find_all.should include valid_sample
    end
  end

  context "#attributes" do
    it "returns a hash" do
      valid_sample.attributes.should be_a Hash
    end

    it "returns a hash including keys for each attribute" do
      attribute1 = :id
      attribute2 = :updated_at
      valid_sample = SalesEngine::ModelSample.new(attribute1 => 7, attribute2 => Date.today)
      valid_sample.attributes.should include :id
      valid_sample.attributes.should include :updated_at
    end
  end

  context "#find_by_" do
    it "created_at" do
      valid_sample
      SalesEngine::ModelSample.find_by_created_at(valid_sample.created_at).should be valid_sample
    end
  end
end
