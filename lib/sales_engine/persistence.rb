require 'singleton'

module SalesEngine
  class Persistence
    include Singleton

    def initialize
      @data = {}
      @indices = {}
    end

    def persist(model)
      name = model.class

      if @data[name]
        @data[name] << model
      else
        @data[name] = [model]
      end
      true
    end

    def exists?(model)
      @data.values.flatten.include? model
    end

    def fetch(class_name)
      @data[class_name] || []
    end

    def fetch_indices(class_name)
      @indices[class_name] || {}
    end

    def clear
      clear_data
      clear_indices
    end

    def clear_indices
      @indices = {}
    end

    def clear_data
      @data = {}
    end

    def index(attribute)
      result = {}

      @data.keys.each do |class_name|
        insert_index(attribute, class_name)
      end
    end

    def insert_index(attribute, class_name)
      result = index_attribute_by_class(attribute, class_name)
      @indices[class_name] = {} unless @indices[class_name]
      @indices[class_name][attribute] = result
    end

    def index_all
      @data.keys.each do |class_name|
        datum = @data[class_name]

        datum.each do |data|
          attributes = data.attributes

          attributes.each do |attribute, value|
            insert_index(attribute, class_name)
          end
        end
      end
    end

    def dump_data
      @data
    end

    def dump_indices
      @indices
    end

    def import(data)
      @data = data
    end

    private

    def index_attribute_by_class(attribute, class_name)
      result = {}

      data = @data[class_name]

      data.each do |model|
        value = model.send(attribute)
        result[value] = model
      end

      result
    end
  end
end
