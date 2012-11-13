module SalesEngine
  module Validation
    def validates_presence_of(key, value, options = {})
      error_msg = "#{self.class} must have #{key}"

      if value.nil?
        raise ArgumentError, error_msg
      elsif not(options[:allow_blank]) && value.to_s.empty?
        raise ArgumentError, error_msg
      else
        true
      end
    end

    def validates_numericality_of(key, value, options = {})
      if options[:integer]
        error_msg = "#{self.class} must have an integer #{key}"
      else
        error_msg = "#{self.class} must have a numeric #{key}"
      end

      target_class = Numeric
      target_class = Integer if options[:integer]

      if value.nil? || !value.is_a?(target_class)
        raise ArgumentError, error_msg
      else
        true
      end
    end
  end
end
