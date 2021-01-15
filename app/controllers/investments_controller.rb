class InvestmentsController < ApplicationController
  before_action :set_investment, only: %i[show edit update destroy]

  # GET /investments
  def index
    @investments = policy_scope(Investment)
      .joins(:asset)
      .select("assets.id AS asset_id, assets.name AS asset_name, assets.abbreviation AS asset_abbreviation, SUM(investments.quantity) AS quantity, SUM(investments.value_invested) AS value_invested")
      .group("assets.id, assets.abbreviation, assets.name")
      .order("assets.abbreviation ASC")

    @total_invested = policy_scope(Investment).sum(:value_invested)

    @total_accumulated = policy_scope(Investment).joins(asset: :current_price)
      .sum("investments.quantity * current_prices.value")
  end

  # GET /investments/1
  def show; end

  # GET /investments/new
  def new
    @investment = Investment.new(asset_id: params[:asset_id])
  end

  # GET /investments/1/edit
  def edit; end

  # POST /investments
  def create
    @investment = current_user.investments.build(investment_params)

    if @investment.save
      redirect_to @investment.asset, notice: "Investment was successfully created."
    else
      render :new
    end
  end

  # PATCH/PUT /investments/1
  def update
    if @investment.update(investment_params)
      redirect_to @investment.asset, notice: "Investment was successfully updated."
    else
      render :edit
    end
  end

  # DELETE /investments/1
  def destroy
    @investment.destroy
    redirect_to @investment.asset, notice: "Investment was successfully destroyed."
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_investment
    @investment = Investment.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def investment_params
    params.require(:investment).permit(:asset_id, :quantity, :value_invested, :invested_at)
  end
end
