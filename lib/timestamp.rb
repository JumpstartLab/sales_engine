require 'date'

class Timestamp
  attr_reader :created_at, :updated_at

  def initialize(created_at = nil, updated_at = nil)
    @created_at = parse_date(created_at) || DateTime.now
  end

  private

  def parse_date(date)
    DateTime.parse(date) if date
  end

end