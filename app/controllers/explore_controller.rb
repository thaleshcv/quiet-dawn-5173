class ExploreController < ApplicationController
  before_action :set_asset_options

  # GET /explore
  def index
    return unless params.key?(:asset_id)

    @explore_facade = ExploreFacade.new(params[:asset_id])
  end

  private

  def set_asset_options
    @asset_options = Asset.order(abbreviation: :asc).collect { |a| ["#{a.abbreviation} - #{a.name}", a.id] }
  end

  def explore_params
    params.permit(:asset_id)
  end
end
