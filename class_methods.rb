module SearchMethods
  def self.extended(base)
    base.class_eval do
      self::ATTRIBUTES.each do |attribute|

        define_singleton_method("find_by_#{attribute}") do |query|
          matches = []
          ObjectSpace.each_object(self) do |instance|
            if instance.send(attribute) == query
              matches << instance 
            end
          end
          matches.first
        end

        define_singleton_method("find_all_by_#{attribute}") do |query|
          matches = []
          ObjectSpace.each_object(self) do |instance|
            if instance.send(attribute) == query
              matches << instance 
            end
          end
          matches
        end

        define_singleton_method("random") do |query|
          all_instances = []
          ObjectSpace.each_object(self) { |instance| all_matched << instance }
          all_instances.shuffle
          all_instances.first
        end

      end
    end
  end
end

module AccessorBuilder
  def self.extended(base)
    base.class_eval do
      self::ATTRIBUTES.each do |attribute|
        attr_accessor attribute
      end
    end
  end

  def define_attributes (attributes)  
    attributes.each do |key, value|
      send("#{key}=",value)
    end
  end

  def headers
    ATTRIBUTES
  end
end

