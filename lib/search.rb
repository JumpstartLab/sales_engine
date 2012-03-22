  module Search

    def self.find_all_by(attribute, match, array)
      found = []
      found = array.select { |item| item.send(attribute.to_sym) == match }
    end

  end