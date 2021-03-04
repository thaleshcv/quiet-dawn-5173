class AssetsController < ApplicationController
  before_action :set_investments_scope, only: %i[show accumulated_series]
  before_action :set_accumulated_value_chart, only: %i[show accumulated_series]

  def index; end

  # GET /assets/1
  def show
    @asset = Asset.find(params[:id])

    @investments = @investments_scope
      .includes(asset: :current_price)
      .order(invested_at: :desc)

    @investment_totals = InvestmentTotalsFacade.new(@investments_scope)
  end

  # GET /assets/1/accumulated_series
  def accumulated_series
    @chart_data = [
      { name: "Accumulated", data: @accumulated_value_chart.accumulated_series },
      { name: "Invested", data: @accumulated_value_chart.invested_series }
    ]
  end

  private

  ACCUMULATED_CHART_RANGES = {
    "30days" => 30,
    "60days" => 60,
    "90days" => 90,
    "1year" => 365
  }.freeze

  def set_investments_scope
    @investments_scope = policy_scope(Investment).where(asset_id: params[:id])
  end

  def set_accumulated_value_chart
    ndays = params.fetch(:ndays, ACCUMULATED_CHART_RANGES["30days"])
    @accumulated_value_chart = AccumulatedValueChartFacade.new(@investments_scope, ndays)
  end
end
