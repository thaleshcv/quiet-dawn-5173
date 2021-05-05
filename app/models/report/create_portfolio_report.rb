# frozen_string_literal: true

# This module implements the creation of a portfolio report for a collection of users.
module Report::CreatePortfolioReport
  extend self

  def perform(users)
    ApplicationRecord.connection.exec_insert(insert_query(users))
  end

  private

  def insert_query(users)
    portfolio_query = Investment
      .for_portfolio
      .where(investments: { user_id: users })
      .order("current_prices.value DESC")
      .to_sql

    <<~SQL
      INSERT INTO reports(created_at, updated_at, user_id, payload)
      (SELECT NOW(), NOW(), portfolio.user_id, ARRAY_TO_JSON(ARRAY_AGG(portfolio))
      FROM (#{portfolio_query}) portfolio
      GROUP BY portfolio.user_id)
    SQL
  end
end
