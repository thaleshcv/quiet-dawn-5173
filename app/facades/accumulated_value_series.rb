class AccumulatedValueSeries
  attr_reader :scope

  def initialize(scope)
    @scope = scope
  end

  def chart_data
    @chart_data ||= scope
      .for_value_accumulated_chart
      .limit(15)
      .collect { |d| [d.date, d.accumulated_value] }
  end
end
