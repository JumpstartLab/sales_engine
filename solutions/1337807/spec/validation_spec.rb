require 'spec_helper'

module SalesEngine
  class ValidationSample
    include Validation

    def nil_value
      validates_presence_of :name, nil
    end

    def blank_false
      validates_presence_of :name, ''
    end

    def blank_true
      validates_presence_of :name, '', :allow_blank => true
    end

    def valid
      validates_presence_of :name, 'Jackie Chan'
    end

    def valid_true
      validates_presence_of :name, 'Jackie Chan', :allow_blank => false
    end

    def numeric_nil
      validates_numericality_of :id, nil
    end

    def numeric_number
      validates_numericality_of :id, 'Jackie Chan'
    end

    def numeric_integer_float
      validates_numericality_of :id, 1.5, :integer => true
    end

    def numeric_integer_false
      validates_numericality_of :id, 1.5, :integer => false
    end
  end
end

describe SalesEngine::Validation do
  let(:sample) { SalesEngine::ValidationSample.new }
  
  context "validates_presence_of" do
    it "raises an error if the value is nil" do
      expect { sample.nil_value }.to raise_error ArgumentError
    end

    it "raises an error if the value is blank and allow_blank option is false" do
      expect { sample.blank_false }.to raise_error ArgumentError
    end

    it "returns true if the value is blank and allow_blank option is true" do
      sample.blank_true.should be_true
    end

    it "returns true if the value isn't nil or blank" do
      sample.valid.should be_true
    end

    it "returns true if the value isn't nil or blank and allow_blank option is false" do
      sample.valid_true.should be_true
    end
  end

  context "validates_numericality_of" do
    it "raises an error if the value is nil" do
      expect { sample.numeric_nil }.to raise_error ArgumentError  
    end

    it "raises an error if the value is not a number" do
      expect { sample.numeric_number }.to raise_error ArgumentError  
    end

    it "raises an error if the integer option is true and the value is a float" do
      expect { sample.numeric_integer_float }.to raise_error ArgumentError  
    end

    it "returns true if the value is a float and the integer option is false" do
      sample.numeric_integer_false.should be_true
    end
  end
end
