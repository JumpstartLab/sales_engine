require './spec/spec_helper'

describe Timestamp do
  before(:each) do
    @timestamp = Timestamp.new
  end

  context "timestamp with arguments" do
    it 'parses a string argument as a date attribute named created_at' do
      timestamp = Timestamp.new("2012-02-26 20:56:56 UTC")
      timestamp.created_at.to_s.should == "2012-02-26 20:56:56 UTC"
    end

    it 'returns a DateTime object when created_at is called' do
      timestamp = Timestamp.new("2012-02-26 20:56:56 UTC")
      timestamp.created_at.class.should == DateTime
    end

    it 'accepts an updated_at argument' do
      Timestamp.new(nil, "1979-03-18")
    end
    
    it 'parses a string argument as a date attribute named updated_at' do
      timestamp = Timestamp.new(nil, "1979-03-18")
      timestamp.updated_at.to_s.should == "1979-03-18"
    end
  end

  context "timestamp without arguments" do
    it 'has a created_at attribute' do
      @timestamp.created_at.should_not be_nil
    end

    it 'returns a DateTime object when created_at is called' do
      @timestamp.created_at.class.should == DateTime
    end

    it 'has an updated_at attribute' do
      @timestamp.updated_at.should_not be_nil
    end
  end
end