class Merchant
  attr_reader :created_at
  attr_reader :id

  def initialize(attributes)
    @id = attributes[:id]
    name = attributes[:name]
    @created_at = parse_date(attributes[:created_at])

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

  def parse_date(date)
    date = DateTime.now.to_s if date.to_s.empty?
    DateTime.parse date
  end
end
