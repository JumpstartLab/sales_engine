module Sanitize

    def sanitize_unit_price(original_price)
      BigDecimal(original_price.to_s)/100
    end

end