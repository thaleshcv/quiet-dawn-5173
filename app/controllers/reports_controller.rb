class ReportsController < ApplicationController
  def index
    @reports = policy_scope(Report).order(created_at: :desc)
  end

  def show
    @report = policy_scope(Report).find(params[:id])
  end
end
