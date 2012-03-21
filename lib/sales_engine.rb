module SalesEngine
  def self.find_by(elements, attribute, value)
    if elements
      elements.find { |element| element.send(attribute) == value[0] }
    else
      nil
    end
  end

  def self.find_all_by(elements, attribute, value)
    if elements
      elements.select{ |element| element.send(attribute) == value[0] }
    else
      []
    end
  end

  def respond_to?(meth)
    if meth.to_s =~ /^find_by_.*$/ || meth.to_s =~ /^find_all_by_.*$/
      true
    else
      super
    end
  end

  module ClassMethods
    def method_missing(meth, *args, &block)
      if meth.to_s =~ /^find_by_(.+)$/
        SalesEngine::find_by(Database.merchants, $1, args)
      elsif meth.to_s =~ /^find_all_by_(.+)$/
        SalesEngine::find_all_by(Database.merchants, $1, args) 
      else
        super
      end
    end
  end

  def self.included(target)
    target.extend(ClassMethods)
  end
end