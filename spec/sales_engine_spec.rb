require './spec/spec_helper.rb'

describe "Sales Engine" do

  let(:sample_engine) { SalesEngine.new }

  before(:each) do
    sample_engine.merchants = ["merchant1", "merchant2"]
  end

	context "gets an array" do

		it "gets merchants" do
      sample_engine.merchants.should == ["merchant1", "merchant2"]
		end

	end

end