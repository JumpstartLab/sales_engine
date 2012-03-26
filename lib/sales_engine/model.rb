require './lib/sales_engine/validation'

module SalesEngine
  module Model
    include Validation

    attr_reader :id, :created_at, :updated_at
    attr_accessor :models
    
    def initialize(attributes)
      @models = {}
      @id = attributes[:id]
      @created_at = attributes[:created_at] || DateTime.now
      @updated_at = attributes[:updated_at] || @created_at

      validates_numericality_of :id, @id, :integer => true
    end

    private

    def update!
      @updated_at = DateTime.now
    end
    
    def self.included(target)
      target.extend ClassMethods
    end

    module ClassMethods
      def find(id)
      end
    end
  end
end
