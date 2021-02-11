class AssetsController < ApplicationController
  def index; end

  def show
    @asset = Asset.find(params[:id])

    base_scope = policy_scope(Investment).where(asset_id: params[:id])

    @investments = base_scope
      .includes(asset: :current_price)
      .order(invested_at: :desc)

    @investment_totals = InvestmentTotals.new(base_scope)
  end
end
