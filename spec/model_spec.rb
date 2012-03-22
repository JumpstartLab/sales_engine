require './spec/spec_helper'

module SalesEngine
  class ModelSample
    include Model
  end
end

describe SalesEngine::Model do
  let(:valid_sample) { SalesEngine::ModelSample.new :id => 1 }

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

    it "raises an error unless given an integer id" do
      expect do
        SalesEngine::ModelSample.new :id => 1.5 
      end.to raise_error ArgumentError
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
end
