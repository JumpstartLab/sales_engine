  module Search

    def hello
      puts "Foo"
    end

    def self.find_all_by(attribute, match, array)
      found = []
      found = array.select { |item| item.attribute = match }
    end

    def self.find_by(attribute, match, array)
      find_all_by(attribute, match, array).sample
    end
  end