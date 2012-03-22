require './lib/sales_engine/model'

module SalesEngine
  class Merchant
    include Model

    attr_reader :name

    def initialize(attributes)
      super(attributes)

      validate_name(attributes[:name])
      @name = attributes[:name]
    end

    def name=(name)
      @name = name
      update!
    end

    private

    def validate_name(name)
      unless name.to_s.empty?
        true
      else
        error_msg = 'Merchants must have a name'
        raise ArgumentError, error_msg
      end
    end
  end
end
