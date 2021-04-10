class ExploreController < ApplicationController
  before_action :set_item_options, only: :index
  before_action :set_user_items, only: :index

  # GET /explore
  def index; end

  # GET /explore/items
  def items
    @explore_facade = ExploreFacade.new(params[:item_id])

    redirect_to(explore_path, alert: "The item requested does not exists.") unless @explore_facade.item_exists?
  end

  # GET /explore/prices
  def prices
    return unless params.key?(:item_id)

    @explore_facade = ExploreFacade.new(params[:item_id], params[:range_type])
  end

  private

  def set_user_items
    @user_items = Item.with_investments(policy_scope(Investment))
  end

  def set_item_options
    @item_options = Item.for_select_options
  end
end
