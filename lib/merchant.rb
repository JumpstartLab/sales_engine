class Merchant
  attr_reader :id, :name, :created_at, :updated_at

  def initialize(attributes)
    @id = attributes[:id]
    @name = attributes[:name]
    @created_at = attributes[:created_at] || DateTime.now
    @updated_at = attributes[:updated_at] || @created_at

    error_msg = 'Merchants must have an id and name'
    raise ArgumentError, error_msg unless valid_id?(id) and valid_name?(name)
  end

  def name=(name)
    @name = name
    @updated_at = DateTime.now
  end

  private

  def valid_id?(id)
    true unless id.to_s.empty? || id.to_s.match(/^\D+$/)
  end

  def valid_name?(name)
    true unless name.to_s.empty?
  end
end
