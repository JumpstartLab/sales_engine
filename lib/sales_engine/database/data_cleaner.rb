class DataCleaner
  include Singleton
  def clean_id(id)
    id.only_digits
  end

  def clean_updated_at(date)
    Date.parse(date)
  end

  def clean_created_at(date)
    Date.parse(date)
  end

  def clean_merchant_id(id)
    clean_id(id)
  end

  def clean_item_id(id)
    clean_id(id)
  end
end