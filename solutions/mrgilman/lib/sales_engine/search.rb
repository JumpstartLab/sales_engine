module SalesEngine
  module Search

    def self.find_by_attribute(name, value, array)
      if value.is_a?(String)
        array.detect { |i| i.send(name).downcase == value.downcase }
      else
        array.detect { |i| i.send(name) == value }
      end
    end

    def self.find_all_by_attribute(name, value, array)
      if value.is_a?(String)
        array.select { |i| i.send(name).downcase == value.downcase }
      else
        array.select { |i| i.send(name) == value }
      end
    end
  end
end