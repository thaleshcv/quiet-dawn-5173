class InvestmentsController < ApplicationController
  before_action :set_investment, only: %i[edit update destroy]

  # GET /investments
  def index
    @portfolio = policy_scope(Investment).for_portfolio
    @investment_totals = InvestmentTotalsFacade.new(policy_scope(Investment))
  end

  # GET /investments/new
  def new
    @investment = Investment.new(item_id: params[:item_id])
  end

  # GET /investments/1/edit
  def edit; end

  # POST /investments
  def create
    @investment = current_user.investments.build(investment_params)

    if @investment.save
      redirect_to @investment.item, notice: "Investimento criado com sucesso."
    else
      render :new
    end
  end

  # PATCH/PUT /investments/1
  def update
    @original_item_id = @investment.item_id

    if @investment.update(investment_params)
      redirect_to @investment.item, notice: "Investimento atualizado com sucesso."
    else
      render :edit
    end
  end

  # DELETE /investments/1
  def destroy
    @investment.destroy
    redirect_to @investment.item, notice: "Investimento excluído com sucesso."
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_investment
    @investment = policy_scope(Investment).find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def investment_params
    params.require(:investment).permit(:item_id, :quantity, :value_invested, :invested_at)
  end
end
