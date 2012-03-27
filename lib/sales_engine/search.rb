module SalesEngine
  module Search

#NEED TO MAKE DOWNCASE
    def self.find_all_by(attribute, match, array)
      array.select { |item| item.send(attribute.to_sym) == match }
    end

    def self.find_by(attribute, match, array)
      array.detect { |item| item.send(attribute.to_sym) == match }
    end
  end
end