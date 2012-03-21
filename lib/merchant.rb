require './lib/model'

module SalesEngine
  class Merchant
    include Model

    attr_reader :name

    def initialize(attributes)
      super(attributes)

      @name = attributes[:name]

      error_msg = 'Merchants must have a name'
      raise ArgumentError, error_msg unless valid_name?(name)
    end

    def name=(name)
      @name = name
      update!
    end

    private

    def valid_name?(name)
      true unless name.to_s.empty?
    end
  end
end
