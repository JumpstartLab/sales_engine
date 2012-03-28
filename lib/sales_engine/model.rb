class SalesEngine
  module Model
    def initialize(attributes)
      @id = attributes[:id] 
      @created_at = attributes[:created_at]
      @updated_at = attributes[:updated_at]
    end

    module ClassMethods

    end

    def self.included(target)
      class_name = target.name.split("::").last.underscores
      target.class_eval do
        define_singleton_method ("lucky?").to_sym do
          "lucky!"
        end

        define_singleton_method ("random").to_sym do
          SalesEngine::Database.instance.send(class_name).sample
        end
      end
      target.extend ClassMethods
    end
  end
end

class String
  def underscores
    word = self.dup
    word.gsub!(/::/, '/')
    word.gsub!(/([A-Z]+)([A-Z][a-z])/,'\1_\2')
    word.gsub!(/([a-z\d])([A-Z])/,'\1_\2')
    word.tr!("-", "_")
    word.downcase!
    "#{word}s"
  end
end