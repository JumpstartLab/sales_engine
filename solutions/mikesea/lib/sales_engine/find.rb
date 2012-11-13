require 'sales_engine/database'

module Find

  def find(klass, attribute, match)
    SalesEngine::Database.instance.send(klass).find do |f|
      f.send(attribute.to_sym) == match
    end
  end

  def find_all(klass, attribute, match)
    SalesEngine::Database.instance.send(klass).select do |f|
      f.send(attribute.to_sym) == match
    end
  end

end