class AssetsController < ApplicationController
  def index; end

  def show
    @asset = Asset.find(params[:id])

    @investments = policy_scope(Investment)
      .where(asset_id: params[:id])
      .includes(asset: :current_price)
      .order(invested_at: :desc)

    @investment_totals = InvestmentTotals.new(@investments)
  end
end
