module SalesEngine
  module Model
    attr_reader :id, :created_at, :updated_at
    
    def initialize(attributes)
      @id = attributes[:id]
      @created_at = attributes[:created_at] || DateTime.now
      @updated_at = attributes[:updated_at] || @created_at

      error_msg = 'Models must have an integer id'
      raise ArgumentError, error_msg unless valid_id?(id)
    end

    def valid_id?(id)
      true unless id.to_s.empty? || id.to_s.match(/\D+/)
    end

    private

    def update!
      @updated_at = DateTime.now
    end
  end
end
