class PeriodicReportsJob < ApplicationJob
  queue_as :default

  def perform
    users_with_pending_report.find_in_batches(batch_size: 100) do |users|
      query = insert_query { portfolio_query(users) }
      ApplicationRecord.connection.exec_insert(query)
    end
  end

  private

  def portfolio_query(users)
    Investment
      .for_portfolio
      .where(investments: { user_id: users })
      .order("current_prices.value DESC")
      .to_sql
  end

  def insert_query
    <<~SQL
      INSERT INTO reports(created_at, updated_at, user_id, payload)
      (SELECT NOW(), NOW(), portfolio.user_id, ARRAY_TO_JSON(ARRAY_AGG(portfolio))
      FROM (#{yield}) portfolio
      GROUP BY portfolio.user_id)
    SQL
  end

  def users_with_pending_report
    User.select("users.id, users.email, MAX(reports.created_at) AS last_report_at")
      .left_joins(:reports)
      .having("MAX(reports.created_at) IS NULL OR MAX(reports.created_at) <= ?", 7.days.ago)
      .group("users.id, users.email")
  end
end
