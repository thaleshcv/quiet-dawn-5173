class AccumulatedValueChartFacade
  attr_reader :scope, :range_type

  RANGE_TYPES = {
    "30d" => 30,
    "60d" => 60,
    "90d" => 90
  }.freeze

  DEFAULT_RANGE_TYPE = "30d".freeze

  def initialize(scope, range_type = DEFAULT_RANGE_TYPE)
    @scope = scope
    @range_type = range_type || DEFAULT_RANGE_TYPE
  end

  def range_in_days
    RANGE_TYPES.fetch(range_type, RANGE_TYPES[DEFAULT_RANGE_TYPE])
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

  def min_value
    [accumulated_series.collect(&:last).min, invested_series.collect(&:last).min].min
  end

  def max_value
    [accumulated_series.collect(&:last).max, invested_series.collect(&:last).max].max
  end
end
