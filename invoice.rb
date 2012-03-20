class Invoice
  ATTRIBUTES = ["merchant_id","id","customer_id","status","created_at", "updated_at"]
  class_eval do
    ATTRIBUTES.each do |attribute|
      attr_accessor attribute.to_sym
      
      define_singleton_method("find_by_#{attribute}") do |query|
        matches = []
        ObjectSpace.each_object(Invoice) do |invoice|
          if invoice.send(attribute) == query
            matches << invoice 
          end
        end
        matches.first
      end

      define_singleton_method("find_all_by_#{attribute}") do |query|
        matches = []
        ObjectSpace.each_object(Invoice) do |invoice|
          if invoice.send(attribute) == query
            matches << invoice 
          end
        end
        matches
      end
      
    end
  end
end