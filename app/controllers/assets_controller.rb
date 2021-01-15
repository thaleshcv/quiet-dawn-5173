class AssetsController < ApplicationController
  def index; end

  def show
    @asset = Asset.find(params[:id])

    @investments = policy_scope(Investment)
      .where(asset_id: params[:id])
      .includes(asset: :current_price)
      .order(invested_at: :desc)

    @total_invested = @investments.sum(:value_invested)

    @current_value = @investments.sum("investments.quantity * current_prices.value")
  end
end
