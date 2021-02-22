class AccumulatedValueChart
  attr_reader :scope, :range_in_days

  def initialize(scope, range_in_days = 30)
    @scope = scope
    @range_in_days = range_in_days
  end

  def accumulated_series
    @accumulated_series ||= scope
      .for_value_accumulated_series(range_in_days)
      .collect { |d| [d.date, d.accumulated_value] }
  end

  def invested_series
    @invested_series ||= scope
      .for_total_invested_series(range_in_days)
      .collect { |d| [d.date, d.total_invested] }
  end
end
