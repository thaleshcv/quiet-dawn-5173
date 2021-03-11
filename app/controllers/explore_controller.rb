class ExploreController < ApplicationController
  before_action :set_asset_options, only: :index
  before_action :set_user_assets, only: :index

  # GET /explore
  def index; end

  # GET /explore/assets
  def assets
    @explore_facade = ExploreFacade.new(params[:asset_id])

    redirect_to(explore_path, alert: "The asset requested does not exists.") unless @explore_facade.asset_exists?
  end

  # GET /explore/prices
  def prices
    return unless params.key?(:asset_id)

    @explore_facade = ExploreFacade.new(params[:asset_id], params[:range_type])
  end

  private

  def set_user_assets
    @user_assets = Asset.with_investments(policy_scope(Investment))
  end

  def set_asset_options
    @asset_options = Asset.for_select_options
  end
end
