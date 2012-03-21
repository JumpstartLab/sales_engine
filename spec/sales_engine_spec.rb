require "./lib/sales_engine"
 require 'spec_helper'

describe SalesEngine do
  describe ".find_by" do
    context "database has elements to search" do
      let(:elements) { ["food", "bar", "baz"] }
                
      it "finds first matching attribute" do
        elements = ["food", "bar", "baz"]
        result = SalesEngine::find_by(elements, "length", [3])
        result.should == "bar"
      end

      it "finds nil with no matching attribute" do
        elements = ["food", "bar", "baz"]
        result = SalesEngine::find_by(elements, "length", [10])
        result.should == nil
      end
    end

    context "database has no matching elements" do
      it "returns nil if elements is nil" do
        elements = nil
        result = SalesEngine::find_by(elements, "length", [10])
        result.should == nil
      end
    end
  end
end