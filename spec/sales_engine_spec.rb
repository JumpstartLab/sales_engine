require 'spec_helper'
require "./lib/sales_engine"


describe SalesEngine do
  describe ".find_by" do
    context "database has elements to search" do
      let(:elements) { ["food", "bar", "baz"] }
                
      it "finds first matching attribute" do
        result = SalesEngine::find_by(elements, "length", [3])
        result.should == "bar"
      end

      it "finds nil with no matching attribute" do
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

  describe ".find_all_by" do
    context "database has elements to search" do
      let(:elements) { ["food", "bar", "baz"] }
                
      it "finds all matching attributes" do
        result = SalesEngine::find_all_by(elements, "length", [3])
        result.should == ["bar", "baz"]
      end

      it "finds nil with no matching attribute" do
        result = SalesEngine::find_all_by(elements, "length", [10])
        result.should == []
      end
    end

    context "database has no matching elements" do
      it "returns nil if elements is nil" do
        elements = nil
        result = SalesEngine::find_all_by(elements, "length", [10])
        result.should == []
      end
    end
  end
end