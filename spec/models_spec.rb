require "spec_helper"

describe "Models" do
  models = {SalesEngine::Merchant => "merchants", 
            SalesEngine::Item => "items",
            SalesEngine::InvoiceItem => "invoice_items",
            SalesEngine::Invoice => "invoices",
            SalesEngine::Transaction => "transactions",
            SalesEngine::Customer => "customers"}

  models.each do |model, method|
    describe ".random" do
      context "when database has #{method} loaded" do
        before(:each) do
          @elements = 10.times.collect { mock(model) } 
          SalesEngine::Database.stub(method).and_return(@elements)
        end

        it "returns a random object from #{method} array" do
          Random.stub(:rand).and_return(5)
          model.random.should == @elements[5]
        end
      end

      context "when database has no #{method}" do
        it "returns nil" do
          model.random.should == nil
        end
      end
    end

    describe ".find_by" do
      let(:element) { mock(model) }
      let(:element2) { mock(model) }
      let(:element3) { mock(model) }
      let(:duplicate_element) { mock(model) }
      let(:elements) { [element, element2, element3, duplicate_element] }

      before(:each) do
        element.stub(:id).and_return(1)
        element2.stub(:id).and_return(2)
        element3.stub(:id).and_return(3)
        duplicate_element.stub(:id).and_return(1)
      end

      it "calls find_by attribute" do
        SalesEngine::Database.stub(method).and_return(elements)
        model.find_by_id(2).should == element2
      end
    end

    describe ".find_all_by" do
      let(:element) { mock(model) }
      let(:element2) { mock(model) }
      let(:duplicate_element) { mock(model) }
      let(:elements) { [element, element2, duplicate_element] }

      before(:each) do
        element.stub(:id).and_return(1)
        element2.stub(:id).and_return(2)
        duplicate_element.stub(:id).and_return(1)
      end

      it "calls find_all_by attribute" do
        SalesEngine::Database.stub(method).and_return(elements)
        model.find_all_by_id(1).should == [element, duplicate_element]
      end
    end

    describe "method missing" do
      it "invokes the normal no method error" do
        expect{model.foo}.should raise_error
      end
    end
  end
end