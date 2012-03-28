module SalesEngine
  class Record
    attr_accessor :id, :created_at, :updated_at

    def initialize(attributes = {})
      self.id = attributes[:id].to_i
      self.created_at = attributes[:created_at] || Time.now.to_s
      self.updated_at = attributes[:updated_at] || Time.now.to_s
    end

    def convert_to_big_decimal(value)
      value = 0 if value.nil?
      value = value.to_f/100
      BigDecimal.new(value.to_s)
    end
  end
end