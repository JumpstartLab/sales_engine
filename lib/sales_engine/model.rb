require 'validation'

module SalesEngine
  module Model
    include Validation

    attr_reader :id, :created_at, :updated_at, :attributes
    attr_accessor :models

    def initialize(attributes)
      super(attributes)

      @attributes = attributes
      @models = {}
      @id = clean_integer(attributes[:id])
      @created_at = clean_date(attributes[:created_at]) || DateTime.now
      @updated_at = clean_date(attributes[:updated_at]) || @created_at

      validates_numericality_of :id, @id, :integer => true

      SalesEngine::Persistence.instance.persist self
    end

    private

    def clean_integer(number)
      number = number.to_s
      number.to_i if number.match(/^\d+$/)
    end

    def clean_float(float)
      float = float.to_s
      float.to_f if float.match(/^\d+(\.\d+)?$/)
    end

    def clean_date(date)
      if date.is_a? String
        DateTime.parse(date)
      else
        date
      end
    end

    def update!
      @updated_at = DateTime.now
    end

    def self.included(target)
      target.extend ClassMethods
    end

    module ClassMethods
      def find(id)
        find_by_id(id)
      end

      def find_all
        SalesEngine::Persistence.instance.fetch(self)
      end

      def random
        SalesEngine::Persistence.instance.fetch(self).shuffle.first
      end

      def method_missing(sym, *args, &block)
        attribute, finder = parse_finder_attribute(sym.to_s)

        if attribute && finder
          if finder == 'find_by'
            find_by(attribute, *args)
          elsif finder == 'find_all_by'
            find_all_by(attribute, *args)
          end
        else
          super
        end
      end

      def parse_finder_attribute(finder)
        match = finder.match(/^(find_by)_(.+)$/)
        match = finder.match(/^(find_all_by)_(.+)$/) unless match

        if match && match.length > 2
          [match[2], match[1]]
        else
          return nil
        end
      end

      def find_by(attribute, *values)
        attribute = attribute.to_sym
        value = values[0]

        indices = SalesEngine::Persistence.instance.fetch_indices(self)

        unless indices.empty?
          model = indices[attribute][value] if indices[attribute]
        end

        unless model
          models = SalesEngine::Persistence.instance.fetch(self)
          model = models.find { |m| m.send(attribute) == value }
        end

        model
      end

      def find_all_by(attribute, *values)
        attribute = attribute.to_sym
        value = values[0]

        models = SalesEngine::Persistence.instance.fetch(self)
        model = models.find_all { |m| m.send(attribute) == value }
      end
    end
  end
end
