class ExploreController < ApplicationController
  before_action :set_asset_options, only: :index
  before_action :set_user_assets, only: :index

  # GET /explore
  def index
    return unless params.key?(:asset_id)

    @explore_facade = ExploreFacade.new(params[:asset_id])
    render :show
  end

  private

  def set_user_assets
    @user_assets = Asset.with_investments(policy_scope(Investment))
  end

  def set_asset_options
    @asset_options = Asset.for_select_options
  end

  def explore_params
    params.permit(:asset_id)
  end
end
