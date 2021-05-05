class PortfolioReportsJob < ApplicationJob
  queue_as :default

  def perform
    User.for_portfolio_report.find_in_batches(batch_size: 100) do |users|
      Report::CreatePortfolioReport.perform(users)
    end
  end
end
