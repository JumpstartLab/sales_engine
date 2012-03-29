class SalesEngine
  module Model
    def initialize(attributes)
      @id = attributes[:id] 
      @created_at = attributes[:created_at]
      @updated_at = Time.parse(attributes[:updated_at])
    end

    def self.included(target)
      class_name = target.name.split("::").last.underscores
      target.class_eval do
        define_singleton_method ("random").to_sym do
          SalesEngine::Database.instance.send(class_name).sample
        end
      end

      target.finder_attributes.each do |att|
        target.class_eval do
          define_singleton_method ("find_by_" + att).to_sym do |param|
            SalesEngine::Database.instance.find_by(class_name, att, param)
          end

          define_singleton_method ("find_all_by_" + att).to_sym do |param|
            SalesEngine::Database.instance.find_all_by(class_name, att, param)
          end
        end
      end
    end
  end
end

# underscores and adds s to end of a string, for converting
# class names into database accessors
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