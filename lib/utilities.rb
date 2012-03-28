class Array
  def sum
    self.inject(0, :+)
  end

  def pop_multiple(pop_count)
    return_array = []

    if self.length > pop_count
      pop_count.to_i.times do
        return_array << self.pop
      end
    else
      return_array = self
    end

    return_array
  end
end