class ExploreController < ApplicationController
  before_action :set_asset_options, only: :index
  before_action :set_user_assets, only: :index

  # GET /explore
  def index
    return unless params.key?(:explore)

    @explore_facade = ExploreFacade.new(explore_params[:asset_id])
    render :show
  end

  # GET /explore/prices
  def prices
    return unless params.key?(:asset_id)

    @explore_facade = ExploreFacade.new(params[:asset_id], params[:range_type])
  end

  # GET /explore/assets
  def assets
    @assets = Asset.abbreviation_or_name_like(params[:query])
    render json: @assets
  end

  private

  def set_user_assets
    @user_assets = Asset.with_investments(policy_scope(Investment))
  end

  def set_asset_options
    @asset_options = Asset.for_select_options
  end

  def explore_params
    params.require(:explore).permit(:asset_id, :asset_name)
  end
end
