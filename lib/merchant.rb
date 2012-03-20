class Merchant
  def initialize(attributes)
    id = attributes[:id]
    name = attributes[:name]
    error_msg = 'Merchants must have an id and name'

    raise ArgumentError, error_msg unless valid_id?(id) and valid_name?(name)
  end

  private

  def valid_id?(id)
    true unless id.to_s.empty? || id.to_s.match(/^\D+$/)
  end

  def valid_name?(name)
    true unless name.to_s.empty?
  end
end