module SalesEngine
  module Search

#NEED TO MAKE DOWNCASE
    def self.find_all_by(attribute, match, array)
      if match.is_a?(String)
        array.select { |item| item.send(attribute.to_sym).downcase == match.downcase }
      else
        array.select { |item| item.send(attribute.to_sym) == match }
      end
    end

    def self.find_by(attribute, match, array)
      if match.is_a?(String)
        array.detect { |item| item.send(attribute.to_sym).downcase == match.downcase }
      else
        array.detect { |item| item.send(attribute.to_sym) == match }
      end
    end
  end
end