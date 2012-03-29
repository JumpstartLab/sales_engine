module Cleaner
  def self.fetch_id(object_type, *id)
    if id.any?
      id.first.to_i
    else
      list = "#{object_type}_list"
      ( SalesEngine::Database.instance.send(list).size + 1 ).to_i
    end
  end

  def self.fetch_date(*date)
    if date.any?
      Date.parse(date.first)
    else
      Date.today
    end
  end

  def self.fetch_price(price)
    return nil if price.nil?
    
    if price.class == BigDecimal
      price
    else
      BigDecimal.new(price)/100
    end
  end
end