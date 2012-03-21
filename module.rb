  module Search

    def hello
      puts "Foo"
    end

    def self.find_all_by(attribute, match, array)
      found = []
      found = array.select { |item| item.send(attribute.to_sym) == match }
    end

    def self.find_by(attribute, match, array)
      mel =  find_all_by(attribute, match, array).sample
      puts mel.send(attribute.to_sym)
    end
  end