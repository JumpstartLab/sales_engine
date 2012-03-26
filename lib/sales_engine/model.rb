class SalesEngine
  module Model
    def initialize(attributes)
      @id = attributes[:id] 
      @created_at = attributes[:created_at]
      @updated_at = attributes[:updated_at]
    end
  end
end