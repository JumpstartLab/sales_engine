module SalesEngine
  module DynamicFinder
    def self.extended(target)
      class_name = target.name.downcase.split("::").last
      target.attributes_for_finders.each do |att|
        target.class_eval do
          define_singleton_method ("find_by_" + att).to_sym do |param|
            SalesEngine::Database.instance.find(class_name, att, param)
          end

          define_singleton_method ("find_all_by_" + att).to_sym do |param|
            SalesEngine::Database.instance.find_all(class_name, att, param)
          end
        end
      end
    end
  end
end