module SearchMethods
  def self.extended(base)
    base.class_eval do
      self::ATTRIBUTES.each do |attribute|
        attr_accessor attribute.to_sym

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

      end
    end
  end
end

