require 'singleton'

module SalesEngine
  class Persistence
    include Singleton

    def initialize
      @models = {}
    end

    def persist(model)
      name = model.class.to_s

      begin
        if @models[name]
          @models[name] << model
        else
          @models[name] = [model]
        end
        true
      rescue
        false
      end
    end

    def exists?(model)
      @models.values.flatten.include? model
    end

    def fetch(class_name)
      @models[class_name.to_s] || []
    end

    def clear
      @models = {}
    end
  end
end
