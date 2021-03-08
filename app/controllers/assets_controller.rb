class AssetsController < ApplicationController
  before_action :set_investments_scope, only: %i[show accumulated]
  before_action :set_accumulated_value_chart, only: %i[show accumulated]

  # GET /assets/1
  def show
    @asset = Asset.find(params[:id])

    @investments = @investments_scope
      .includes(asset: :current_price)
      .order(invested_at: :desc)

    @investment_totals = InvestmentTotalsFacade.new(@investments_scope)
  end

  # GET /assets/1/accumulated
  def accumulated
    @chart_data = [
      { name: "Accumulated", data: @accumulated_value_chart.accumulated_series },
      { name: "Invested", data: @accumulated_value_chart.invested_series }
    ]
  end

  private

  def set_investments_scope
    @investments_scope = policy_scope(Investment).where(asset_id: params[:id])
  end

  def set_accumulated_value_chart
    @accumulated_value_chart = AccumulatedValueChartFacade.new(@investments_scope, params[:range_type])
  end
end
