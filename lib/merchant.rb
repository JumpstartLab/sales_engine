class Merchant
  attr_accessor :id, :name, :created_at, :updated_at
  
  def initialize(id, name, created_at, updated_at)

  end

  def self.find_by(attribute, value)
    merchants = Database.merchants
    if merchants

    merchants.find do |merchant| 
      merchant.send(attribute) == value[0] 
    end
    else
      nil
    end
  end

  def self.random
    merchants = Database.merchants
    if merchants && merchants.length > 0
      merchants[Random.rand(Database.merchants.length - 1)]
    else
      nil
    end
  end

  def self.method_missing(meth, *args, &block)
    if meth.to_s =~ /^find_by_(.+)$/
      self.find_by($1, args)
    else
      super
    end
  end

  def respond_to?(meth)
        if meth.to_s =~ /^find_by_.*$/
          true
        else
          super
        end
  end
end

