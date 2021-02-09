class InvestmentTotals
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
    @total_accumulated ||= scope.joins(asset: :current_price)
      .sum("investments.quantity * current_prices.value")
  end
end
