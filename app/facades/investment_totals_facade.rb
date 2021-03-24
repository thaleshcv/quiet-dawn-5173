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
    @total_invested ||= scope.total_invested
  end

  def total_accumulated
    @total_accumulated ||= scope.total_accumulated
  end
end
