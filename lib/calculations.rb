# A set of methods with non-usual calculations
# This module extends ActiveSupport::Concern, so it can be used as such
# in any class across the application.
module Calculations
  extend ActiveSupport::Concern

  included do
    # Calculates the difference from current to initial in percentage.
    # Let's say, initial is 10 and current is 8, so the result will be -20 (20%).
    # Also, if initial is 10 and current is 15, this results in 50 (+50%).
    #
    # Both initial and current can be a Numeric, String or Symbol.
    # When Numeric or String, they will parsed to float using to_f method.
    # If you pass a symbol, then it will be treated as a method name and the result
    # of that method will be used.
    def difference_in_percent(initial, current)
      # avoiding division by zero and NaN values
      initial_value = parse_value(initial)
      current_value = parse_value(current)

      if initial_value.to_f.zero? || current_value.to_f.zero?
        0
      else
        ((current_value / initial_value) - 1) * 100
      end
    end

    private

    def parse_value(value)
      case value
      when Numeric, String
        value.to_f
      when Symbol
        send(value)
      else
        raise ArgumentError, "Type not supported"
      end
    end
  end
end
