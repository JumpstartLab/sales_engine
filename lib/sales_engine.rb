module SalesEngine
  def self.find_by(elements, attribute, value)
    if elements
      elements.find { |element| element.send(attribute) == value[0] }
    else
      nil
    end
  end

  def self.print
    puts "wtf"
  end
end