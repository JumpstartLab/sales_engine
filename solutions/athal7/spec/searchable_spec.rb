require './spec/spec_helper'

CLASSES = {SalesEngine::Merchant => "merchants", SalesEngine::Customer => "customers", SalesEngine::Item => "items", SalesEngine::Invoice => "invoices", SalesEngine::InvoiceItem => "invoice_items", SalesEngine::Transaction => "transactions"}

CLASSES.each do |klass, attribute|
  describe "#{klass}" do

    describe ".random" do
      it "returns a single instance of #{klass}" do
        klass.send(:random).should be_a(klass)
      end
    end

    describe ".find_by_id(7)" do
      it "returns one instance of #{klass} with ID 7" do
        klass.send(:find_by_id, 7).id.should == 7
      end
    end

    describe ".find_all_by_id(10)" do
      it "returns all instances of #{klass} with ID 10 " do
        klass.send(:find_all_by_id, 10).map(&:id).should == [10]
      end
      it "doesn't miss any records with id of 10" do
        all_tens = klass.send(:find_all_by_id, 10)
        (klass.all - all_tens).map(&:id).include?(10).should be_false
      end
    end

    describe ".find_all_by_id('f')" do
      it "returns an empty array" do
        klass.send(:find_all_by_id, 'f').map(&:id).should == []
      end
    end

    #TODO: Assert error message includes faulty method name
    describe ".find_by_foo_bar(42)" do
      it "raises a method missing error" do
        expect { klass.send(:find_by_foo_bar, 42) }.should raise_error(NoMethodError)
      end
    end
  end
end


describe SalesEngine::Customer do
  describe ".find_all_by_first_name" do
    it "returns all instances of Customer with first_name Bobbie" do
      SalesEngine::Customer.find_all_by_first_name("Bobbie").size.should == 2
      SalesEngine::Customer.find_all_by_first_name("Bobbie").map(&:first_name).uniq.should == ["Bobbie"]
    end
    it "is case insensitive" do
      SalesEngine::Customer.find_all_by_first_name("bobbie").size.should == 2
      SalesEngine::Customer.find_all_by_first_name("bobbie").map(&:first_name).uniq.should == ["Bobbie"]
    end
  end


  describe ".find_by_first_name('Bobbie')" do
    it "returns one instance of Customer with first name Bobbie" do
      SalesEngine::Customer.find_by_first_name('Bobbie').first_name.should == 'Bobbie'
    end
  end

  describe ".find_all_by_last_name" do
    it "returns all instances of Customer with last_name Johnsons" do
      SalesEngine::Customer.find_all_by_last_name("Johnson").size.should == 5
      SalesEngine::Customer.find_all_by_last_name("Johnson").map(&:last_name).uniq.should == ["Johnson"]
    end
    it "is case insensitive" do
      SalesEngine::Customer.find_all_by_last_name("johnson").size.should == 5
      SalesEngine::Customer.find_all_by_last_name("johnson").map(&:last_name).uniq.should == ["Johnson"]
    end
  end
end
