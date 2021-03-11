require "calculations"

class InvestmentTotalsFacade
  include Calculations

  attr_reader :scope

  def initialize(scope)
    @scope = scope
  end

  def quantity
    @quantity ||= scope.sum(:quantity)
  end

  def total_invested
    @total_invested ||= scope.sum(:value_invested)
  end

  def total_accumulated
    @total_accumulated ||= scope
      .joins(:asset)
      .left_joins(asset: :current_price)
      .sum(<<~SQL)
        COALESCE(
          investments.quantity * current_prices.value,
          investments.value_invested::money::numeric::float8
        )
      SQL
  end
end
