module SalesEngine
  class Record
    attr_accessor :id, :created_at, :updated_at

    def initialize(attributes = {})
      self.id = attributes[:id]
      self.created_at = attributes[:created_at]
      self.updated_at = attributes[:updated_at]
    end
  end
end